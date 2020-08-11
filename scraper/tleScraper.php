
<?php


	$source = "catalog12a.txt";
	$fileh = fopen($source, "r");
	
	$target = "catclip.xml";
	$outpf  = fopen($target, "w"); 
	
	$target2 = "names.txt";
	//$outpf2  = fopen($target2, "w"); 
	
	$firstNames = array(); 
	
	$count = 0;
	fprintf($outpf, "<satdata>\n");
	while ((!feof($fileh))&&($count<4000000)) {  
	
		///////////////////////////////////// line 1
		$oneLine = fgets($fileh, 4096);
				
		// detect "DEB" or "R/B" in the name line
		$isDeb = false; 
		if (strpos($oneLine, "DEB")>2) { 
			$isDeb = true;
		}
		if (strpos($oneLine, "R/B")>2) { 
			$isDeb = true;
		}
		// save the name 
		$name = $oneLine; 	
			
		// search the array of names for this one
		$parts = explode(" ", $oneLine); 
		$aName = $parts[0]; 
		$size = count($firstNames);
		$found=0;  
		for ($i=0; $i< $size; ++$i) {
			if (strcmp($firstNames[$i],$aName)==0) { 
				$found =1; 
			}
		}
		if ($found==0) {
		//	fprintf($outpf2, "<satName> %s </satName><countryOfOrigin> NAME HERE </countryOfOrigin>\n", $aName);  
			$firstNames[$size] = $aName;
		}
		
		///////////////////////////////////// line 2
		$oneLine = fgets($fileh, 4096);
		$norad = substr ($oneLine, 2, 5);
		$launchYear = substr ($oneLine, 9, 2);
		$launchYear += 1900; 
		if ($launchYear<1957) { $launchYear +=100; }
		$launchCount = substr ($oneLine, 11, 3);
		$piece = substr ($oneLine, 14, 1);
		$year = substr ($oneLine, 18, 2);
		$day = substr ($oneLine, 20, 12);
		
		$dmdt = substr ($oneLine, 33, 10);
		
		///////////////////////////////////// line 3	
		$oneLine = fgets($fileh, 4096);
		$ic = substr ($oneLine, 8, 8);
		$ra = substr ($oneLine, 17, 8);
		$ec = substr ($oneLine, 26, 7);
		$ap = substr ($oneLine, 34, 8);
		$an = substr ($oneLine, 43, 8);
		$mo = substr ($oneLine, 52, 12);
	
	
		if ($isDeb==true) { 
			fprintf($outpf, "<sat>\n"); 
			fprintf($outpf, "  <name>$name</name>\n");			
			fprintf($outpf, "  <norad>$norad</norad><day>$day</day>\n");			
			fprintf($outpf, "  <ic>$ic</ic><ra>$ra</ra>\n");			
			fprintf($outpf, "  <ec>$ec</ec><ap>$ap</ap>\n");			
			fprintf($outpf, "  <an>$an</an><mo>$mo</mo>\n");			
			fprintf($outpf, "</sat>\n"); 
			$count = $count +1; 
			
		}
		
	}
	fprintf($outpf, "</satdata>\n");
	fclose($outpf);
	//	fclose($outpf2);
	fclose($fileh);
	printf("count: %d, name count %d\n", $count, $size); 

?>
