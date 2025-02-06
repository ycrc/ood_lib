def getHostSpecs()
    hostname = %x(#{"hostname"})
    host_specs = {'host':'', 'libpath':''}
    if hostname.include? "grace" then
        host_specs[:host] = "Grace"
        host_specs[:libpath] = "/vast/palmer/apps/services/ood/share/lib"
    elsif hostname.include? "mccleary" then
        host_specs[:host] = "McCleary"
        host_specs[:libpath] = "/vast/palmer/apps/services/ood/share/lib"
    elsif hostname.include? "misha" then
        host_specs[:host] = "Misha"
        host_specs[:libpath] = "/gpfs/radev/apps/services/ood/share/lib"
    elsif hostname.include? "milgram" then
        host_specs[:host] = "Milgram"
        host_specs[:libpath] = "/gpfs/milgram/apps/services/ood/var_www_ood_apps/lib"
    elsif hostname.include? "bouchet" then
        host_specs[:host] = "Bouchet"
        host_specs[:libpath] = "/opt/ood/lib"
    end
    
    return host_specs

end
