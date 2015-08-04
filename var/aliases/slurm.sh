# Copyright 2015 Victor Penso
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.


alias s=slurm

# Catch all to shorten access ti slurm* functions 
function slurm {
  case $1 in
    n|nodes)
      shift
      case $1 in
        u|users)
          slurm-node-users 
          ;;
        d|draining)
          sinfo -t drain,draining,drained -R
          ;;
        *)
          sinfo -N
          ;;
      esac
      ;;
    q|queue)
      slurm-queue
      ;;
    r|report)
      shift
      case $1 in
        a|accounts)
          sreport cluster accountutilizationbyuser start=$(date --date="90 days ago" +"%Y-%m-%d") tree
          ;;
        *)
          sreport user top start=$(date --date="90 days ago" +"%Y-%m-%d") 
          ;;
      esac
      ;;
    j|jobs)
      shift
      case $1 in
        c|completed)
          slurm-jobs-completed
          ;;
        f|failed)
          slurm-jobs-failed
          ;;
        p|pending)
          slurm-jobs-pending
          ;;
        t|time)
          slurm-jobs-time
          ;;
        *)
          slurm-jobs-running
          ;;
      esac
      ;;
    *)
      help
      ;;
  esac
}

function help {
echo "slurm (j)obs  [(c)ompleted|(f)ailed|(p)ending|(t)ime] 
      (n)odes [(d)raining|(u)sers]
      (r)eport [(a)ccounts]
      (q)ueue"

}


function slurm-node-users() {
  squeue \
    --states RUNNING \
    --sort 'N' \
    --format '%12N %10u %2t %3h' \
    | uniq -c 
}


function slurm-jobs-pending {
  squeue -o '%.9Q %.9P %.8u %.8T %.10M %.8Dx%5C' \
         -S '-p' \
         --state=pending \
         | uniq -c
}

function slurm-jobs-running {
  squeue \
    --states RUNNING \
    --format '%20S %11M %9P %8u %6g %10T %11l' \
    | sort -k 1 \
    | uniq -f 2 -c \
    | tac
}

function slurm-queue {
  squeue \
    --all \
    --sort '-T,P,u,m,C,D,l,t' \
    --format '%9P %8u %6g %9T %.4Cx%5D %7m %11l %8f %6b %6q %8W' \
    | uniq -c
}

function slurm-jobs-time() {
  squeue \
    --all \
    --sort '-M,T' \
    --format '%11M %11l %8T %8u %6P %6a %20S' \
    | uniq -c
}

function slurm-jobs-failed {
  sacct \
    --noheader --allocations --allusers \
    --starttime $(date --date="14 days ago" +"%Y-%m-%d") \
    --state failed,node_fail,timeout \
    --format end,user,account,state,exitcode \
    | sort -k 1 \
    | uniq -f 1 -c
}

function slurm-jobs-completed {
  sacct --state completed \
        --noheader \
        --allusers \
        --starttime $(date --date="1 days ago" +"%Y-%m-%d")\
        --format end,elapsed,user,nnodes \
        --allocations \
        | sort -k 1 \
        | uniq -c

}
