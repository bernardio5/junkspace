
<?php

/* 
bytes   format   units  label   explainations
 76- 77  I2     h         RAh        ?Hours RA, equinox J2000, epoch 2000.0 (1)
  78- 79  I2     min       RAm        ?Minutes RA, equinox J2000, epoch 2000.0 (1)
  80- 83  F4.1   s         RAs        ?Seconds RA, equinox J2000, epoch 2000.0 (1)
      84  A1     ---       DE-        ?Sign Dec, equinox J2000, epoch 2000.0 (1)
  85- 86  I2     deg       DEd        ?Degrees Dec, equinox J2000, epoch 2000.0 (1)
  87- 88  I2     arcmin    DEm        ?Minutes Dec, equinox J2000, epoch 2000.0 (1)
  89- 90  I2     arcsec    DEs        ?Seconds Dec, equinox J2000, epoch 2000.0 (1)
  103-107  F5.2   mag       Vmag       ?Visual magnitude (1)


okay, astronomers are dicks. hours minutes seconds epoch 2000? could you just give me an angle, bithches? 

2PI radians = 24 hours
1 hour = PI/12
1 min = PI/720
1 sec = PI/43200



*/

$target = "catalog.txt";
$fileIn = fopen($target, "r");
$fileOut = fopen("stars.xml", "w"); 

fprintf($fileOut, "<stars>\n"); 
$radHrs = 3.14159265358979 /12.0; 	
$radMin = $radHrs / 60.0 ;	
$radSec = $radMin / 60.0;

$radDeg = 3.14159265358979 / 180.0; 
$radDegMin = $radDeg / 60.0; 
$radDegSec = $radDegMin / 60.0; 

$counter = 0; 
$brt = 0.0; 

while ((!feof($fileIn))&&($counter<4000)) {  // each line of the file contains one description. 

		$line = fgets($fileIn, 200);  
	
		$name = substr($line, 0, 8); 
		$con = substr($line, 11, 3); 
		$conN = 0; 
		if(strcmp($con, "UMa")==0) { $conN=1; }
		if(strcmp($con, "UMi")==0) { $conN=2; }
		if(strcmp($con, "Ori")==0) { $conN=3; }
		if(strcmp($con, "Peg")==0) { $conN=4; }
		if(strcmp($con, "Cas")==0) { $conN=5; }
		if(strcmp($con, "And")==0) { $conN=6; }
		if(strcmp($con, "Psc")==0) { $conN=1; }
		if(strcmp($con, "Peg")==0) { $conN=2; }
		if(strcmp($con, "Scl")==0) { $conN=3; }
		if(strcmp($con, "Cet")==0) { $conN=4; }
		if(strcmp($con, "Cet")==0) { $conN=5; }
		if(strcmp($con, "Phe")==0) { $conN=6; }
		if(strcmp($con, "Tuc")==0) { $conN=1; }
		if(strcmp($con, "Vul")==0) { $conN=2; }
		if(strcmp($con, "Cyg")==0) { $conN=3; }
		if(strcmp($con, "Agl")==0) { $conN=4; }
		if(strcmp($con, "Sge")==0) { $conN=5; }
		if(strcmp($con, "Sex")==0) { $conN=6; }
		if(strcmp($con, "Leo")==0) { $conN=1; }
		if(strcmp($con, "Car")==0) { $conN=2; }
		if(strcmp($con, "Her")==0) { $conN=3; }
		if(strcmp($con, "Aur")==0) { $conN=4; }
		if(strcmp($con, "Oph")==0) { $conN=5; }
		if(strcmp($con, "Dra")==0) { $conN=6; }
	
		$rh = substr($line, 75, 2); 
		$rh = $rh / 12; 
		$rm = substr($line, 77, 2); 
		$rm = $rm / (12*60); 
		$rs = substr($line, 79, 4); 
		$rs = $rs / (12*60 *60);
		$raRad = 3.114159265358979 * ($rh+$rm+$rs);

		$dcSign = substr($line, 83, 1); 
		$dd = substr($line, 84, 2); 
		$dm = substr($line, 86, 2); 
		$ds = substr($line, 88, 2); 
		$dcRad = ($dd*$radDeg)+ ($dm*$radDegMin)+ ($ds*$radDegSec);
		if (strcmp($dcSign, "-")==0) { $dcRad = $dcRad * -1.0; }

		$apMag = substr($line, 102, 5); 
		$brt = 0.0; 
		if ($apMag<4.5) { $brt = 1.5 + $apMag; }
		if ($raRad*$raRad<0.00000001) { $brt = 0.0; }
	
	
		if ($brt>0.1) { 
			printf("%s %15.5f %15.5f %15.5f %15.5f\n", $name, $rh, $rm, $rs, $raRad);  
			printf("%8d %15.5f %15.5f %15.5f %15.5f\n\n", $counter, $dd, $dm, $ds, $dcRad);  
			fprintf($fileOut, "<star><con>%d</con><mag>%f</mag><ra>%f</ra><dc>%f</dc></star>\n", $conN, $brt, $raRad, $dcRad); 
 			$counter = $counter +1; 
		}
		
}
fclose($fileIn);
fprintf($fileOut, "</stars>\n"); 

fclose($fileOut);
	

	

?>
