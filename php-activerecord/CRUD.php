<?php
require __DIR__.'/initialize.php';

// Create
Person::create(['name' => 'kimromi1']);

$p = new Person();
$p->name = 'kimromi2222';
$p->save();

// Read
Person::all();
Person::first();
Person::find(1);
Person::find_by_name('kimromi2');
var_dump(Person::all(['group' => 'name', 'having' => 'length(name) > 9']));

// Update
$p = Person::first();
$p->name = 'kimromi3';
$p->save();
$p->reload();

$p->update_attributes([
    'name' => 'kimromi4'
]);

// Delete
$p->delete_all(['conditions' => ['name = ?', 'kimromi4']]);
