#include <iostream>
#include <vector>

#include <AMReX_MultiFab.H>
#include <AMReX_Print.H>
#include <AMReX_VisMF.H>
#include <AMReX_ParmParse.H>

#include "mechanism.h"
#include <GPU_misc.H>
#include <AMReX_GpuDevice.H>

#include <main_F.H>
#include <PlotFileFromMF.H>

std::string inputs_name = "";

using namespace amrex;

int
main (int   argc,
      char* argv[])
{
    Initialize(argc,argv);
    {

      ParmParse pp;
    
      std::string probin_file = "probin";
      pp.query("probin_file",probin_file);
      int probin_file_length = probin_file.length();
      std::vector<int> probin_file_name(probin_file_length);

      for (int i = 0; i < probin_file_length; i++)
	probin_file_name[i] = probin_file[i];

      int fuel_idx = FUEL_ID;
      int oxy_idx  = OXY_ID;
      int bath_idx = BATH_ID;

      extern_init(&(probin_file_name[0]),&probin_file_length,&fuel_idx,&oxy_idx,&bath_idx);
    
      std::vector<int> npts(3,1);
      for (int i = 0; i < BL_SPACEDIM; ++i) {
	npts[i] = 128;
      }
      npts[1] = 256;
    
      Box domain(IntVect(D_DECL(0,0,0)),
                 IntVect(D_DECL(npts[0]-1,npts[1]-1,npts[2]-1)));

      std::vector<Real> plo(3,0), phi(3,0), dx(3,1);
      for (int i=0; i<BL_SPACEDIM; ++i) {
	phi[i] = domain.length(i);
	dx[i] = (phi[i] - plo[i])/domain.length(i);
      }
    
      int max_size = 32;
      pp.query("max_size",max_size);
      BoxArray ba(domain);
      ba.maxSize(max_size);

      int num_spec;
      num_spec = NUM_SPECIES;

      DistributionMapping dm{ba};

      int num_grow = 0;
      MultiFab mass_frac(ba,dm,num_spec,num_grow);
      MultiFab temperature(ba,dm,1,num_grow);
      MultiFab density(ba,dm,1,num_grow);

      IntVect tilesize(D_DECL(10240,8,32));
    
      int count_box = 0;
      for (MFIter mfi(mass_frac,tilesize); mfi.isValid(); ++mfi) {
	const Box& box = mfi.tilebox();
	initialize_data(ARLIM_3D(box.loVect()), ARLIM_3D(box.hiVect()),
			BL_TO_FORTRAN_N_3D(mass_frac[mfi],0),
			BL_TO_FORTRAN_N_3D(temperature[mfi],0),
			BL_TO_FORTRAN_N_3D(density[mfi],0),
			&(dx[0]), &(plo[0]), &(phi[0]));
        count_box += 1;
      }
      std::cout << "That many boxes (64)" << count_box <<std::endl; 

      ParmParse ppa("amr");
      std::string pltfile("plt");  
      ppa.query("plot_file",pltfile);
      std::string outfile = amrex::Concatenate(pltfile,0); // Need a number other than zero for reg test to pass
      PlotFileFromMF(temperature,outfile);

      MultiFab wdots(ba,dm,num_spec,num_grow);
    
#ifdef _OPENMP
#pragma omp parallel if (Gpu::notInLaunchRegion())
#endif
      for (MFIter mfi(mass_frac,TilingIfNotGPU()); mfi.isValid(); ++mfi) {

        //std::cout << " **MFITER** " <<std::endl;
	const Box& box = mfi.tilebox();

	const auto  mf      = mass_frac.array(mfi);
	const auto  temp    = temperature.array(mfi);
	const auto  rho     = density.array(mfi); 
	const auto  cdots   = wdots.array(mfi);

	/* AMREX VERSION */
	//amrex::ParallelFor(box,
	//    [=] AMREX_GPU_DEVICE (int i, int j, int k) noexcept
	//    {
	//	gpu_RTY2W(i, j, k, rho, temp, mf, cdots);
	//    });

        /* UNWRAPPED VERSION 1 */
	int ncells = box.numPts();
	const auto lo  = amrex::lbound(box);
	const auto len = amrex::length(box);
	const auto ec = Gpu::ExecutionConfig(ncells);
	//amrex::launch_global<<<ec.numBlocks, ec.numThreads, ec.sharedMem, amrex::Gpu::gpuStream()>>>(
	//[=] AMREX_GPU_DEVICE () noexcept {
	//    for (int icell = blockDim.x*blockIdx.x+threadIdx.x, stride = blockDim.x*gridDim.x;
	//        icell < ncells; icell += stride) {
        //        printf(" icell  %d \n", icell);
	//        int k =  icell /   (len.x*len.y);
	//	int j = (icell - k*(len.x*len.y)) /   len.x;
	//	int i = (icell - k*(len.x*len.y)) - j*len.x;
	//	i += lo.x;
	//	j += lo.y;
	//	k += lo.z;
        //        printf(" i j k %d %d %d \n",i,j,k);
	//	gpu_RTY2W(i, j, k, rho, temp, mf, cdots);
	//    }
	//});

        /* UNWRAPPED VERSION 2 */
        MyLaunchTest<<<ec.numBlocks, ec.numThreads, ec.sharedMem, amrex::Gpu::gpuStream()>>> (ncells, rho, temp, mf, cdots, len.x, len.y, lo.x, lo.y, lo.z);

      }


      outfile = amrex::Concatenate(pltfile,1); // Need a number other than zero for reg test to pass
      PlotFileFromMF(wdots,outfile);

      extern_close();

    }

    Finalize();

    return 0;
}
