#!/usr/bin/php -e
<?php
/* ==========================================
 * Setup Functions
 * ==========================================
 */
function rl(?string $prompt = null) {
    if ($prompt !== null && $prompt !== '') {
        echo $prompt;
    }
    $line = fgets(STDIN);
    // readline() removes the trailing newline, fgets() does not,
    // to emulate the real readline(), we also need to remove it
    if ($line !== false && strlen($line) >= strlen(PHP_EOL) && substr_compare($line, PHP_EOL, -strlen(PHP_EOL)) === 0) {
        $line = substr($line, 0, -strlen(PHP_EOL));
    }
    return $line;
}


function getSW() {
	$w=0;
      preg_match_all("/rows.([0-9]+);.columns.([0-9]+);/", strtolower(exec('stty -a |grep columns')), $output);
      if(sizeof($output) == 3) {
        //return $output[2][0];
        $w = $output[2][0];
        if($w % 2 != 0){$w = $w - 1;}
        return $w;
      }
}
function getSH() {
      preg_match_all("/rows.([0-9]+);.columns.([0-9]+);/", strtolower(exec('stty -a |grep columns')), $output);
      if(sizeof($output) == 3) {
        return $output[1][0];
      }
}
$c['---']=39; // Default
$c['blk']=30; 
$c['red']=31; 
$c['grn']=32; 
$c['ylw']=33; 
$c['blu']=34; 
$c['mag']=35; 
$c['cyn']=36; 
$c['lgry']=37;
$c['dgry']=90; 
$c['lred']=91; 
$c['lgrn']=92; 
$c['lylw']=93;
$c['lblu']=94;
$c['lmag']=95;
$c['lcyn']=96;
$c['wht']=97;
global $c;


/* ==========================================
 * Drawing Primitives
 * ==========================================
 */

/* === Change the FG and BG colours === */
function col($fg,$bg="---"){
  global $c;
  echo "\033[".$c[$fg].";".($c[$bg]+10)."m";
}

/* === Clears the Console Window === */
function clr(){ 
  echo chr(27).chr(91).'H'.chr(27).chr(91).'J';
}


/* === Centered Text === */
function txCntr($width,$text="text"){
  $ln = strlen($text);
  if($ln%2 != 0){$ln++;}
  $width = $width - $ln;
  col("dgry");
  for($x=0;$x<($width/2)-1;$x++){ echo "."; }
  col("---");
  echo " ".$text." ";
  col("dgry");
  for($x=0;$x<$width/2;$x++){ echo "."; }
  col("---");
  echo "\n";
}
/* === Right Aligned Text === */
function txRight($width,$text="text"){
  $ln = strlen($text)+1;
  if($ln%2 != 0){$ln++;}
  $width = $width - $ln;
  col("dgry");
  for($x=0;$x<$width;$x++){ echo "."; }
  col("---");
  echo " ".$text;
  echo "\n";
}
/* === Left aligned text === */
function txLeft($width,$text="text"){
  $ln = strlen($text)+1;
  $width = $width - $ln;
  col("---");
  echo $text." ";
  col("dgry");
  for($x=0;$x<$width;$x++){ echo "."; }
  col("---");
  echo "\n";
}


/* ===  Title in a Thicc Line === */
function lnTitle($width,$text="Title"){
  $ln = strlen($text);
  $st = "";
  for($a=0;$a<$ln;$a++){ $st = $st. strtoupper($text[$a])." "; }
  $ln = strlen($st)+6;
  $width = $width - $ln;
  col("blu");
  for($x=0;$x<$width/2;$x++){ echo "="; }
  col("blk","lylw");
  echo "   ".$st."   ";
  col("blu");
  for($x=0;$x<$width/2;$x++){ echo "="; }
  col("---");
  echo "\n";
}


/* === Thicc Line === */
function lnThk($width){
  for($x=0;$x<$width;$x++){ echo "="; }
  echo "\n";
}
/* === Thin Line === */
function lnThn($width){
  for($x=0;$x<$width;$x++){ echo "-"; }
  echo "\n";
}

    
/* ===========================================================
 * Calls below here
 * ===========================================================
 */

$sw = getSW();
$sh = getSH();
clr();
lnThk($sw);
txRight($sw,"Width:".$sw);
txRight($sw,"Height:".$sh);


lnTitle($sw,"lnTitle");
echo "\n";
lnThn($sw);

txLeft($sw,"txLeft: This is Left.");
echo "\n";
txCntr($sw,"txCntr: This is Centered.");
echo "\n";
txRight($sw,"txRight: This is Right.");
echo "\n";
lnThn($sw);
echo "\n";
lnThk($sw);

col("grn");
$data = rl("Please enter your name.: ");
col("---");

if($data){echo "Thankyou. You entered '".$data."'\n";}
col("---");
?>
