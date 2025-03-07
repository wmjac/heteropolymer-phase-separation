#!/bin/bash
#SBATCH --job-name=t-cycle        # job name for temperature cycling
#SBATCH --nodes=1                 # node count
#SBATCH --ntasks=1                # single task
#SBATCH --cpus-per-task=1         # number of CPU cores per task
#SBATCH --mem-per-cpu=800M        # memory per CPU core
#SBATCH --gres=gpu:1              # number of GPUs per node
#SBATCH --time=03:59:00           # time limit (HH:MM:SS)
#SBATCH --array=1-75              # Array of 75 jobs (number of sequences)

set -euf -o pipefail

# This script runs simulation to temperature cycle the initialized condensed phase

seq_index=${SLURM_ARRAY_TASK_ID}
data_dir="<path-to-data-files>"  # dir containing epsilon and sequence data
epsilon_file="$data_dir/epsilon.csv"  # file with seqID and epsilon values
seqs_file="$data_dir/seqs-ps.lst"  # file with sequence IDs and sequences

# Get seqID, sequence, and epsilon for the current job from CSV file
subdir_line=$(sed -n "${line_number}p" "$epsilon_file")
seqid=$(echo "$subdir_line" | awk -F ',' '{print $1}')      # seqid in the first column
sequence=$(echo "$subdir_line" | awk -F ',' '{print $2}')  # sequence in the second column
epsilon=$(echo "$subdir_line" | awk -F ',' '{print $4}')   # epsilon value in the fourth column

echo "Sequence ID: $seqid"
echo "Sequence: $sequence"
echo "Epsilon: $epsilon"

# Create dir for this sequence
mkdir -p "$seqid"
cd "$seqid"

# Copy input files for temperature cycling
keyfiles_dir="<path-to-keyfiles>"  # dir with keyfiles for temperature cycling
cp "$keyfiles_dir/run_temp-cycle.sh" .
cp "$keyfiles_dir/temp-cycle.in" .

# Replace with seq-specific epsilon
sed -i "s/{epsilon}/$epsilon/g" temp-cycle.in
sed -i "s/{trial_number}/1/g" temp-cycle.in

module purge
export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
export SRUN_CPUS_PER_TASK=$SLURM_CPUS_PER_TASK

singularity run --nv -B $PWD:/host_pwd --pwd /host_pwd $HOME/software/lammps_container/lammps_10Feb2021.sif ./run_temp-cycle.sh > "${seqid}-temp-cycle-trial1.log" 2>&1
