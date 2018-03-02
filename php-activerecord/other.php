<?php
require __DIR__.'/initialize.php';

$p = Person::create(['name' => 'kimromi1']);

// serializer
$p->to_json();
$p->to_array();
$p->to_csv();
$r=$p->to_xml();


var_dump($r);
