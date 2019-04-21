#!/bin/bash
#----------------------------------------------------
# Example SLURM job script to run OpenMP applications
# on TACC's Maverick system.
#----------------------------------------------------
#SBATCH -J ME397_MIDTERM_Q2	      			# Job name
#SBATCH -o ME397_MIDTERM_Q2.out   			# Name of stdout output file(%j expands to jobId)
#SBATCH -p gpu                   			# Submit to the 'normal' or 'development' queue
#SBATCH -N 1                        		# Total number of nodes requested 
#SBATCH -n 1                       		# Total number of mpi tasks requested
#SBATCH -t 00:15:00                 			# Run time (hh:mm:ss) - 5 min
#SBATCH -A ME397M-Applied-Engin         	# 'ME397M-Applied-Engin' is the name of the project with the Maverick allocation
#SBATCH --mail-user=akshay@ices.utexas.edu	# email address to use
#SBATCH --mail-type=begin  	   				# email me when the job starts
#SBATCH --mail-type=end    	   				# email me when the job finishes

module load intel/15.0.3
module load mvapich2/2.1
module load Rstats
module load tidyr
#module load randomcoloR

Rscript VARANASI_AKSHAY_ME397M_MIDTERM_TASK_2.R

