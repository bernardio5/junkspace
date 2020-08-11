
<?php

/* 

This is not the one. You want TLEScraper

http://www.amsat.org/amsat/keps/kepmodel.html
http://www.braeunig.us/space/orbmech.htm


there are ~15,000 satellites
take care that you corellate the ID numbers. 




0) All angles are measured w.r.t the center of the earth and the 
	direction of the vernal equinox. 	
	The location of the vernal equinox varies.
	yfract = fraction of year since vernal equinox
	dfract = fraction of day since vernal equinox
	lat = 23.44 * sin (2 * PI * yfract); 
	lon = ((dfract + yfract)*360.0; 
	
	start by assuming them to be 0,0
	compute the sat's lat/lon by orbit shape and position in the orbit
	then add the actual position of the base in? 

1) inclination and ascending node give the plane of the orbit

2) eccentricity gives shape of orbit, periapsis gives angle from 
	
	
3) 


*/

$target = "catalog927.txt";
$fileh = fopen($target, "r");
	
while (!feof($fileh)) {  // read each line of the page

		$name = fgets($fileh, 36);  // read first line-- the common name
		// pull name out of first 24 characters
		
		$oneLine = fgets($fileh, 80);  // read second line
		$tags = explode(" ", $oneLine, 80); 
		
		$epoch = $tags[3]; 
		$dm = $tags[4]; 
		$ddm = $tags[5]; 
	
		$oneLine = fgets($fileh, 80);  // read third line
		$tags = explode(" ", $oneLine, 80); 
		
		$id = $tags[1] + 0; 
		$inclination = $tags[2] + 0.0;
		$raan = $tags[3] + 0.0;
		$ecc = $tags[4] / 10000000.0;
		$perigee = $tags[5] + 0.0;
		$anomaly = $tags[6] + 0.0; 
		$motion = $tags[7] + 0.0; 
		
		// I can get the shape from this, and the speed, but not the position
		
		printf("%s %15.5f %15.5f %15.5f %15.5f\n", $name, $ecc, $perigee, $anomaly, $motion);  
		
		// conversion: 
		// we want a formula that converts 
			
		// yeah, I forget how to get time.
 		$time = 0; 
		
		
		
		
		
}
fclose($fileh);
	

	

?>
