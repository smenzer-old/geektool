<?php
//$url = "http://weather.yahoo.com/united-states/new-york/new-york-12761342/";
$ch = curl_init();
$timeout = 20; // set to zero for no timeout
curl_setopt ($ch, CURLOPT_RETURNTRANSFER, 1);
curl_setopt ($ch, CURLOPT_CONNECTTIMEOUT, $timeout);

$zip_url = "http://api.ipinfodb.com/v3/ip-city/?key=b71b829fe073b62d61ed97fb9b306b152414cf44c23cceb25495ed3918d5c2cc&format=json&ip=".$_SERVER["REMOTE_ADDR"];
curl_setopt ($ch, CURLOPT_URL, $zip_url);
$zip_json = json_decode(curl_exec($ch), true);
$zip = $zip_json["zipCode"];


$location_url = "http://weather.yahoo.com/locationWidget/widget/htdocs/locationWidget.php?appId=us_weather&useFallback=false&filter_country=US&filter_name=USA&filter_status=FALSE&locale=en-US&language=ENG&showRecent=true&showSaved=false&showForm=false&showCheckbox=true&showDefault=true&rnd=1316639934013&default=&location=$zip";
curl_setopt ($ch, CURLOPT_URL, $location_url);
$location = curl_exec($ch);

$location_json = preg_replace('/\<!\-\-.*/','',$location);
$location_array = json_decode($location_json, true);
unset($location_array["html"]);

foreach ($location_array["locations"] as $id=>$val) {
	$location_id = $id;
	break;
}

$weather_url = "http://weather.yahoo.com/redirwoei/$location_id";

curl_setopt ($ch, CURLOPT_FOLLOWLOCATION,1); // follow redirects
curl_setopt ($ch, CURLOPT_URL, $weather_url);
$file_contents = curl_exec($ch);
curl_close($ch);

$divStart = "<div class=\"forecast-icon\"";
$strEnd = "'); _background-image/* */: none;";
$start = strpos($file_contents, $divStart) + 50;
$end = strpos($file_contents, $strEnd);
$length = $end-$start;

$imagepath=substr($file_contents, $start , $length);
$image=imagecreatefrompng($imagepath);

imagealphablending($image, true);
imagesavealpha($image, true);
header('Content-Type: image/png');
imagepng($image);
?>

