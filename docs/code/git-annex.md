


Why git-annex

* backups
* location tracking
* data preservation


`git annex add` includes a file into the repository:

* Checksums the file, the resulting hash will be used a new name
* Copy the original file into the git repository `.git/annex/objects` using the hash-name
* Create a link to the repository file with the original name within the git working tree 








[ftr] Git Annex Future Proofing  
http://git-annex.branchable.com/future_proofing

[rmt] Git Annex Special Remotes  
http://git-annex.branchable.com/special_remotes
