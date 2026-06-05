<?php

use Illuminate\Contracts\Http\Kernel;
use Illuminate\Http\Request;

define('LARAVEL_START', microtime(true));

$homeCacheFile = __DIR__ . '/../storage/framework/cache/home-page.html';
$isGuestHomeRequest = ($_SERVER['REQUEST_METHOD'] ?? 'GET') === 'GET'
    && parse_url($_SERVER['REQUEST_URI'] ?? '/', PHP_URL_PATH) === '/'
    && empty($_SERVER['QUERY_STRING'])
    && empty($_COOKIE['rocketlms_session']);

if ($isGuestHomeRequest && is_file($homeCacheFile)) {
    header('Content-Type: text/html; charset=UTF-8');
    readfile($homeCacheFile);
    exit;
}

@require_once __DIR__ . '/../storage/framework/cache/cache-bootstrap.php';

/*
|--------------------------------------------------------------------------
| Check If The Application Is Under Maintenance
|--------------------------------------------------------------------------
|
| If the application is in maintenance / demo mode via the "down" command
| we will load this file so that any pre-rendered content can be shown
| instead of starting the framework, which could cause an exception.
|
*/

if (file_exists($maintenance = __DIR__.'/../storage/framework/maintenance.php')) {
    require $maintenance;
}

/*
|--------------------------------------------------------------------------
| Register The Auto Loader
|--------------------------------------------------------------------------
|
| Composer provides a convenient, automatically generated class loader for
| this application. We just need to utilize it! We'll simply require it
| into the script here so we don't need to manually load our classes.
|
*/

require __DIR__.'/../vendor/autoload.php';

/*
|--------------------------------------------------------------------------
| Run The Application
|--------------------------------------------------------------------------
|
| Once we have the application, we can handle the incoming request using
| the application's HTTP kernel. Then, we will send the response back
| to this client's browser, allowing them to enjoy our application.
|
*/

$app = require_once __DIR__.'/../bootstrap/app.php';

$kernel = $app->make(Kernel::class);

$request = Request::capture();
$response = $kernel->handle($request);

if ($isGuestHomeRequest && $response->getStatusCode() === 200) {
    @file_put_contents($homeCacheFile, $response->getContent(), LOCK_EX);
}

$response->send();

$kernel->terminate($request, $response);
