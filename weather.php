<?php
$ch = curl_init();
$timeout = 20; // set to zero for no timeout
curl_setopt ($ch, CURLOPT_RETURNTRANSFER, 1);
curl_setopt ($ch, CURLOPT_CONNECTTIMEOUT, $timeout);

$zip_url = "http://api.ipinfodb.com/v3/ip-city/?key=b71b829fe073b62d61ed97fb9b306b152414cf44c23cceb25495ed3918d5c2cc&format=json&ip=".$_SERVER["REMOTE_ADDR"];
curl_setopt ($ch, CURLOPT_URL, $zip_url);
$zip_json = json_decode(curl_exec($ch), true);
$zip = $zip_json["zipCode"];

$location_url = "http://weather.yahooapis.com/forecastrss?p=$zip&u=f";
curl_setopt ($ch, CURLOPT_URL, $location_url);
$location = curl_exec($ch);

$location_xml = simplexml_load_string($location);
$weather_url = (isset($location_xml->channel->item->link)) ? $location_xml->channel->item->link : null;

if ($weather_url) {
	curl_setopt ($ch, CURLOPT_FOLLOWLOCATION,1); // follow redirects
	curl_setopt ($ch, CURLOPT_URL, $weather_url);
	$file_contents = curl_exec($ch);
	curl_close($ch);

	$divStart = "<div class=\"current-weather\" id=\"obs-current-weather\" style=\"background:url('";
	$strEnd = "') no-repeat scroll 0% 0% transparent; _background-image/* */:";
	$start = strpos($file_contents, $divStart) + strlen($divStart);
	$end = strpos($file_contents, $strEnd);
	$length = $end-$start;

	$imagepath=substr($file_contents, $start , $length);
	$image=imagecreatefrompng($imagepath);

	imagealphablending($image, true);
	imagesavealpha($image, true);
	header('Content-Type: image/png');
	imagepng($image);
}
