#encoding: utf-8
namespace :meminfo do
  desc "linux - centos"
  task :centos do
    params = {}
    params[:hostname] = `/bin/hostname`
    params[:ip] = `ifconfig|sed  -n  -e '/inet6/d' -e '/Bcast/p'|cut -d : -f 2|awk '{print $1}'`
    meminfo = IO.read("/proc/meminfo")
    params[:unit]        = "kB"
    params[:mem_total]   = meminfo.scan(/MemTotal:\s+(\d+)\skB/)[0][0] rescue "-"
    params[:mem_free]    = meminfo.scan(/MemFree:\s+(\d+)\skB/)[0][0] rescue "-"
    params[:percentage]  = eval("%s*100/%s" % [params[:mem_free], params[:mem_total]]) rescue "-1"
    params[:buffers]     = meminfo.scan(/Buffers:\s+(\d+)\skB/)[0][0] rescue "-"
    params[:cached]      = meminfo.scan(/Cached:\s+(\d+)\skB/)[0][0] rescue "-"
    params[:swap_cached] = meminfo.scan(/SwapCached:\s+(\d+)\skB/)[0][0] rescue "-"
    params[:active]      = meminfo.scan(/Active:\s+(\d+)\skB/)[0][0] rescue "-"
    params[:inactive]    = meminfo.scan(/Inactive:\s+(\d+)\skB/)[0][0] rescue "-"
    puts params
  end
end
