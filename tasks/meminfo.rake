#encoding: utf-8
namespace :meminfo do
  desc "linux - centos"
  task :centos do
    hash = {}
    hash[:HostName] = `/bin/hostname`.strip
    hash[:IP] = `ifconfig|sed  -n  -e '/inet6/d' -e '/Bcast/p'|cut -d : -f 2|awk '{print $1}'`.strip
    meminfo = IO.read("/proc/meminfo")
    hash[:unit]        = "kB"
    hash[:MemTotal]    = meminfo.scan(/MemTotal:\s+(\d+)\skB/)[0][0] rescue "-"
    hash[:MemFree]     = meminfo.scan(/MemFree:\s+(\d+)\skB/)[0][0] rescue "-"
    hash[:Percentage]  = eval("%s*100/%s" % [hash[:MemFree], hash[:MemTotal]]) rescue "-1"
    hash[:Buffers]     = meminfo.scan(/Buffers:\s+(\d+)\skB/)[0][0] rescue "-"
    hash[:Cached]      = meminfo.scan(/Cached:\s+(\d+)\skB/)[0][0] rescue "-"
    hash[:SwapCached]  = meminfo.scan(/SwapCached:\s+(\d+)\skB/)[0][0] rescue "-"
    hash[:Active]      = meminfo.scan(/Active:\s+(\d+)\skB/)[0][0] rescue "-"
    hash[:Inactive]    = meminfo.scan(/Inactive:\s+(\d+)\skB/)[0][0] rescue "-"

    base     = @settings.base
    task     = @settings.tasks.meminfo
    url      = base.url.strip + task.campaign.path.strip

    params = { :token => task.campaign.token, :data => [hash]}
    response = RestClient.post url, params.to_json, :content_type => :json, :accept => :json
    hash = JSON.parse(response) rescue { code: -1 , info: "local error" }
    puts hash
  end
end
