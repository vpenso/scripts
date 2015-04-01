
function slurm-partitions {
  sinfo --format "%9P  %6g %10l %5w %5D %13C %N"
}

function slurm-job {
  
}


function slurm-jobs-pending {
  squeue -o '%.7i %.9Q %.9P %.8j %.8u %.8T %.10M %.11l %.8D %.5C %R' \
         -S '-p' \
         --state=pending
}

function slurm-jobs-failed {
  sacct --state failed \
        --allusers \
        --starttime $(date --date="3 days ago" +"%Y-%m-%d") \
        --allocations \
        --format jobid,user,nnodes,ncpus,exitcode,elapsed,start,end 
}

function slurm-jobs-completed {
  sacct --state completed \
        --allusers \
        --starttime $(date --date="7 days ago" +"%Y-%m-%d")\
        --format end,user,nnodes,ncpus,nodelist,elapsed \
        --allocations
  
}
