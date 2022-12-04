<?php

foreach ([
    [
        'define("SIVUJETTI_INDEX_PATH", dirname(SIVUJETTI_BACKEND_PATH) . "/")',
        'define("SIVUJETTI_INDEX_PATH", dirname(SIVUJETTI_BACKEND_PATH) . "/html/")',
        '/var/www/sivujetti-backend/cli.php',
    ],
    [
        'define("SIVUJETTI_BACKEND_PATH", SIVUJETTI_INDEX_PATH . "backend/")',
        'define("SIVUJETTI_BACKEND_PATH", dirname(SIVUJETTI_INDEX_PATH) . "/sivujetti-backend/")',
        '/var/www/html/index.php',
    ]
] as [$replace, $with, $filePath]) {
    $orig = file_get_contents($filePath);
    $patched = str_replace($replace, $with, $orig);
    file_put_contents($filePath, $patched);
}
