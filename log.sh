#!/bin/bash

#SBATCH --job-name=log.wait
#SBATCH --output=log/depth_summary_%A_%a.out
#SBATCH --error=log/depth_summary_%A_%a.err
#SBATCH --time=20-20:00:00
#SBATCH --ntasks=1
#SBATCH --mem=10G

echo "done!"


