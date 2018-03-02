<?php
exec('./initialize_database');

require __DIR__.'/vendor/autoload.php';

ActiveRecord\Config::initialize(function($cfg)
{
   $cfg->set_model_directory(__DIR__.'/models');
   $cfg->set_connections(['development' => 'sqlite://test.db']);

   //$cfg->set_logging(true);
   //$cfg->set_logger(new Logger());
});

class Logger
{
    public function log($a) {
        var_dump($a);
    }
}
