require("lfs") 
module("autostart",package.seeall)
-- {{{ Run programm once
function processwalker()
   local function yieldprocess()
      for dir in lfs.dir("/proc") do
        -- All directories in /proc containing a number, represent a process
        if tonumber(dir) ~= nil then
          local f, err = io.open("/proc/"..dir.."/cmdline")
          if f then
            local cmdline = f:read("*all")
            f:close()
            if cmdline ~= "" then
              coroutine.yield(cmdline)
            end
          end
        end
      end
    end
    return coroutine.wrap(yieldprocess)
end

function run_once(process, cmd)
   assert(type(process) == "string")
   local regex_killer = {
      ["+"]  = "%+", ["-"] = "%-",
      ["*"]  = "%*", ["?"]  = "%?" }

   for p in processwalker() do
      if p:find(process:gsub("[-+?*]", regex_killer)) then
	 return
      end
   end
   return awful.util.spawn_with_shell(cmd or process)
end

function run_once_list(list)
	parse(list,run_once)
end

function parse(list,fn)
	for k,v in ipairs(list)do
		if type(v) == "string" then
			v={v}
		end
		fn(unpack(v))
	end
end
--
-- Use the second argument, if the programm you wanna start, 
-- differs from the what you want to search.
--run_once("redshift", "nice -n19 redshift -l 51:14 -t 5700:4500")
