#!/bin/bash
#SBATCH --job-name=gpu_job                # Job name
#SBATCH --partition=compute               # Partition (queue) to submit to
#SBATCH --gres=gpu:1                      # Request 1 GPU
#SBATCH --cpus-per-task=4                 # Number of CPU cores per task
#SBATCH --mem=16G                         # Memory needed per node
#SBATCH --time=01:00:00                   # Time limit (hh:mm:ss)
#SBATCH --output=job_%j.log               # Standard output and error log
#SBATCH --error=job_%j.err                # Error log

# Your GPU-based task, such as a Python script or binary
srun python3 gpu_task.py

