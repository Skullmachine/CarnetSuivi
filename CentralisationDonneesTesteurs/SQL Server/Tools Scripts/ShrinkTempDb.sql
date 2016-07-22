USE tempdb
GO
-- write everything from your buffers to the disc!
CHECKPOINT; 
GO

USE tempdb
GO
-- Clean all buffers and caches
DBCC DROPCLEANBUFFERS; 
DBCC FREEPROCCACHE;
DBCC FREESYSTEMCACHE('ALL');
DBCC FREESESSIONCACHE;
GO

USE tempdb
GO
-- Now shrink the file to your desired size
DBCC SHRINKFILE (TEMPDEV, 1024);
-- Make sure that there is no running transaction which uses the tempdb while shrinking!
-- This is most trickiest part of it all.
GO