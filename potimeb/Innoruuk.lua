local event_counter = 0;

function event_signal(e)
	-- signal 1 comes from my army
	if (e.signal == 1) then
		event_counter = event_counter + 1;
		if (event_counter == 12) then
			-- send a signal to the zone_status that I am depopping
			eq.signal(223097,6);
			-- make myself go away!
			eq.depop();
		end
	end
end