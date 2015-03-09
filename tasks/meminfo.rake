#encoding: utf-8
namespace :meminfo do
  desc "linux - centos"
  task :centos do
    hash = {}
    hash[:hostname] = `/bin/hostname`
    hash[:ip] = `ifconfig|sed  -n  -e '/inet6/d' -e '/Bcast/p'|cut -d : -f 2|awk '{print $1}'`
    hasho = IO.read("/proc/meminfo")
    hash[:unit]        = "kB"
    hash[:mem_total]   = meminfo.scan(/MemTotal:\s+(\d+)\skB/)[0][0] rescue "-"
    hash[:mem_free]    = meminfo.scan(/MemFree:\s+(\d+)\skB/)[0][0] rescue "-"
    hash[:percentage]  = eval("%s*100/%s" % [params[:mem_free], params[:mem_total]]) rescue "-1"
    hash[:buffers]     = meminfo.scan(/Buffers:\s+(\d+)\skB/)[0][0] rescue "-"
    hash[:cached]      = meminfo.scan(/Cached:\s+(\d+)\skB/)[0][0] rescue "-"
    hash[:swap_cached] = meminfo.scan(/SwapCached:\s+(\d+)\skB/)[0][0] rescue "-"
    hash[:active]      = meminfo.scan(/Active:\s+(\d+)\skB/)[0][0] rescue "-"
    hash[:inactive]    = meminfo.scan(/Inactive:\s+(\d+)\skB/)[0][0] rescue "-"

    base     = @settings.base
    task     = @settings.tasks.meminfo
    url      = base.url + task.campaign.path 

    params = { :token => task.campaign.token, :info => hash }
    response = RestClient.post url, params.to_json, :content_type => :json, :accept => :json
    hash = JSON.parse(response) rescue { code: -1 , info: "local error" }
    puts hash
  end
end
