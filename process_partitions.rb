def updatePartitions(cmd, username, partition_file)


  public_partitions_first = []
  public_partitions_last = []

  hostname = %x(#{"hostname"})
  if hostname.include? 'grace'
    # partitions that will appear before the PI partitions
    public_partitions_first = ["devel", "day", "week", "gpu", "gpu_devel", "mpi", "bigmem", "transfer"]
    # partitions that will appear after the PI partitions
    public_partitions_last = ["scavenge", "scavenge_gpu", "legacy", "future"]
  elsif hostname.include? 'milgram'
    public_partitions_first = ["interactive", "day", "week", "gpu"]
    public_partitions_last = ["scavenge"]
  elsif hostname.include? 'mccleary'
    public_partitions_first = ["devel", "day", "week", "gpu", "gpu_devel", "bigmem", "ycga", "transfer"]
    public_partitions_last = ["scavenge_gpu", "scavenge", "future"]
  elsif hosttname.include? 'bouchet'
    public_partitions_first = ["devel", "mpi"]
  end


  run_cmd = cmd + " " + username  
  private_partitions = %x(#{run_cmd}).split("\n")

  # array to store the partition with additional fields with the following format:
  #            partition;partition;max_walltime_in_hours;gpu
  extended_partitions = Array.new
  # add public partitions in the first list
  public_partitions_first.each do |partition|
    if partition.include? "gpu_devel"
      extended_partitions << partition+";"+partition+";6;true"
    elsif partition.include? "devel"
      extended_partitions << partition+";"+partition+";6;false"
    elsif partition.include? "gpu"
      extended_partitions << partition+";"+partition+";24;true"
    elsif partition.include? "week"
      extended_partitions << partition+";"+partition+";48;false"
    else
      extended_partitions << partition+";"+partition+";24;false"
    end
  end
  # add private partitions
  private_partitions.each do |partition|
    partition_name = partition[/PartitionName=(.*?) /m, 1]
    if partition.include? "gpu"
      extended_partitions << partition_name+";"+partition_name+";168;true"
    else
      extended_partitions << partition_name+";"+partition_name+";168;false"
    end
  end
  # add public partitions in the last list
  public_partitions_last.each do |partition|
    if partition.include? "gpu"
      extended_partitions << partition+";"+partition+";24;true"
    else
      extended_partitions << partition+";"+partition+";24;false"
    end
  end

  # dump extended_partitions to partition_file
  f = File.open(partition_file, "w")
  extended_partitions.each do |partition|
    f.write(partition+"\n")
  end
  f.close
end

def processPartitions(libpath)

  cmd = libpath+"/partitions.sh"
  username = ENV['USER']
  partition_file = ENV['HOME'] + "/ondemand/.partitions"
  age = 60  # in seconds = one day
  
  # check if partitions exists
  if (File.file?(partition_file)) then
    # check the time stamp of partitions. Update if it is older than age
    if (Time.now - age > File.ctime(partition_file)) then
      updatePartitions(cmd, username, partition_file)
    end
  else
    updatePartitions(cmd, username, partition_file)
  end 

  if (File.file?(partition_file))
    extended_partitions = File.read(partition_file).split()
  end
  
  return extended_partitions
end
