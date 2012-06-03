<?php
/* Pretends to be a jpg! Will return a jpg, clever eh. */
include "include/include.php";

header('Content-Type: image/jpeg');
// Cache me
// seconds, minutes, hours, days
$expires = 60*60*24*14;
header("Pragma: public");
header("Cache-Control: maxage=".$expires);
header('Expires: ' . gmdate('D, d M Y H:i:s', time()+$expires) . ' GMT');

$id = $_GET['id'];
$size_w = $_GET['width'];
if(isset($_GET['height'])) $size_h = $_GET['height'];
if(!is_numeric($size_w) || $size_w > 1000) die;
if(!isset($_GET['id']) || !preg_match("/^[0-9]+$/", $id)) die;

if(isset($size_h) && (!is_numeric($size_h) || $size_h > 1000)) $size_h = null;


$filename = "/var/www/uploads/$id.jpg";

if(!is_file($filename)) {
	$filename = "/var/www/img/noart.jpg";
	$img = imagecreatefromjpeg($filename);
} else {
	$img = imagecreatefromjpeg($filename);
}

list($width, $height) = getimagesize($filename);
if(isset($size_h) && ($size_w/$size_h) < ($width/$height)){
    $newheight = $size_h;
    $newwidth = ($height/$width)*$size_h;
} else{
    $newwidth = $size_w;
    $newheight = ($height/$width)*$size_w;
}
$out = imagecreatetruecolor($newwidth, $newheight);

imagecopyresampled($out,$img,0,0,0,0,$newwidth,$newheight,$width,$height);
imagejpeg($out);

?>
