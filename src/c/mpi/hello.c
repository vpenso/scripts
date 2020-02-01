/**
 *
 * Simple MPI program sending messages. This kind of program is called
 * Single Program Multiple Data (SPMD) since the if-else statement
 * distinguishes the execution path for different processes by process
 * rank. 
 *
 * The process rank identifies a process by a non-negative integer,
 * starting the count from zero.
 *
 * Compile this program with:
 *
 *   mpicc -o mpi_hello hello.c
 *
 * Execute this program with:
 *
 *   mpiexec -n $processes_total mpi_hello
 *
 **/

#include <unistd.h>
#include <stdio.h>
#include <string.h>
#include <mpi.h>

#define MESSAGE_SIZE 100

int main(int argc, char* argv[]) {
        char message[MESSAGE_SIZE];
        int processes_total;
        int process_rank;

        /*
         * no MPI calls before initialization 
         */

        // define a communicator that consists of all of the processes
        // called MPI_COMM_WORLD
        MPI_Init(&argc, &argv);
        // read information from the communicator
        MPI_Comm_size(MPI_COMM_WORLD, &processes_total);
        MPI_Comm_rank(MPI_COMM_WORLD, &process_rank);


        // all processes except zero
        if (process_rank != 0) {
                // create a message
                sprintf(message, "rank:%d pid:%d", process_rank, getpid());
                // send message to process zero
                MPI_Send(
                         message,            // input buffer holding contents of the message
                         strlen(message)+1,  // size of the message, plus one for \0 terminator
                         MPI_CHAR,           // message data type
                         0,                  // rank of the process that should receive the message
                         0,                  // tag to distinguish message (non-negative integer)
                         MPI_COMM_WORLD      // communicator
                );
        // only in process zero
        } else {
                printf("rank:%d pid:%d\n", process_rank, getpid());

                MPI_Status message_status;
                int message_size;

                // iterate over all other processes
                for (int process = 1; process < processes_total; process++) {
                        // receive a message
                        MPI_Recv(
                                message,                 // output buffer to hold received message
                                MESSAGE_SIZE,            // max. size of the output buffer
                                MPI_CHAR,                // massage data type
                                MPI_ANY_SOURCE,          // process from which the message should be received
                                0,                       // tag...
                                MPI_COMM_WORLD,          // communicator
                                &message_status          // information about the sender
                        );

                        MPI_Get_count(
                                &message_status,          // status of received message 
                                MPI_CHAR,                 // message data type
                                &message_size             // output buffer to write message size to
                        );

                        printf("%s size:%d\n", message, message_size);
                }
        }

        MPI_Finalize();
        
        /*
         * no MPI calls after finalize
         */

        return 0;
}
