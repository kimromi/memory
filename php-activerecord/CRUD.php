<?php
require __DIR__.'/initialize.php';

// Create
Person::create(['name' => 'kimromi1']);

$p = new Person();
$p->name = 'kimromi2';
$p->save();

// Read
Person::all();
Person::first();
Person::find(1);
Person::find_by_name('kimromi2');

// Update
$p = Person::first();
$p->name = 'kimromi3';
$p->save();
$p->reload();

// Delete
$p->delete();
