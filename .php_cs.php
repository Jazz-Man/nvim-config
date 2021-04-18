<?php

/**
 * Rules we follow are from PSR-2 as well as the rectified PSR-2 guide.
 *
 * - https://github.com/FriendsOfPHP/PHP-CS-Fixer
 * - https://github.com/php-fig/fig-standards/blob/master/accepted/PSR-2-coding-style-guide.md
 * - https://github.com/php-fig-rectified/fig-rectified-standards/blob/master/PSR-2-R-coding-style-guide-additions.md
 *
 * If something isn't addressed in either of those, some other common community rules are
 * used that might not be addressed explicitly in PSR-2 in order to improve code quality
 * (so that devs don't need to comment on them in Code Reviews).
 *
 * For instance: removing trailing white space, removing extra line breaks where
 * they're not needed (back to back, beginning or end of function/class, etc.),
 * adding trailing commas in the last line of an array, etc.
 */
$finder = PhpCsFixer\Finder::create()
    ->in(__DIR__)
    ->ignoreDotFiles(true)
    ->ignoreVCS(true)
    // ->ignoreVCSIgnored(false)
    ->ignoreUnreadableDirs()
    ->files()
    ->name('*.php')
    ->exclude(['tests', 'vendor', 'node_modules', '.idea', '.github'])
;

return PhpCsFixer\Config::create()
    ->setRules([
        '@PHP74Migration' => true,
        '@Symfony' => true,
        '@PhpCsFixer' => true,
        '@PSR2' => true,
        '@PSR12' => true,
        '@PSR1' => true,
        // Converts simple usages of `array_push($x, $y);` to `$x[] = $y;`.
        'array_push' => true,
        // PHP arrays should be declared using the configured syntax.
        'array_syntax' => ['syntax' => 'short'],
        // Binary operators should be surrounded by space as configured.
        'binary_operator_spaces' => ['align_double_arrow' => false, 'align_equals' => false],
        // Replaces `dirname(__FILE__)` expression with equivalent `__DIR__` constant.
        'dir_constant' => true,
        // Replace core functions calls returning constants with the constants.
        'function_to_constant' => ['functions' => ['get_called_class', 'get_class', 'get_class_this', 'php_sapi_name', 'phpversion', 'pi']],
        // Use `&&` and `||` logical operators instead of `and` and `or`.
        'logical_operators' => true,
        // Master functions shall be used instead of aliases.
        'no_alias_functions' => ['sets' => ['@all']],
        // There must be no `sprintf` calls with only the first argument.
        'no_useless_sprintf' => true,
    ])->setRiskyAllowed(true)
    ->setFinder($finder)
    ->setUsingCache(true)
;
