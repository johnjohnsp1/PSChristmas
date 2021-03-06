#Requires -version 5.0

<#
pester tests for PSChristmas module
To use this file, change to this directory and run
Invoke-Pester .\psChristmas.tests.ps1
#>

import-module ..\PSChristmas.psd1 -force

InModuleScope PSChristmas {

Describe RequiredFiles {
  It "Has a module file" {
   (Dir ..\*.psm1).count | Should Be 1
  }
  It "Has a manifest file" {
  (Dir ..\*.psd1).count | Should Be 1
  }
  It "Has a json data file" {
  (Dir ..\*.json).count | Should Be 1
  }
}

Describe Data {
 It "JSON file can be converted into an object" {
   {$script:data = Get-Content ..\data.json | ConvertFrom-Json -ErrorAction Stop} | Should Not Throw
 }
 foreach ($item in ("FirstNames","Modifiers","LastNames","Presents","Greeting" )) {
    It "Data has a $item property array" {
        $script:data.$item -is [array] | Should Be True 
 }
 }
 
}

Describe New-Christmas {
 
 It "Runs without error" {
    { $script:x = New-MyChristmas } | Should not Throw
 }

 It "Should be a myChristmas object" {
    $script:x.GetType().Name | Should Be "myChristmas"
 }
 It "Should have a string greeting" {
    $script:x.Greeting.GetType().Name | Should Be "String"
 }
 It "Should have a string Elf name" {
    $script:x.ElfName.GetType().Name | Should Be "String"
 }
 It "Should have [ListStatus] List" {
    $script:x.List.GetType().Name | Should Be "ListStatus"
 }
 It "Daysremaining should be an integer" {
    $script:x.DaysRemaining.GetType().Name | Should Be "Int32"
 }
 It "Countdown should be a string" {
    $script:x.Countdown.GetType().Name | Should Be "string"
 }
}

Describe Get-myChristmasPresent {
 It "Should run without error and return a single entry" {
  (Get-myChristmasPresent).Count | Should be 1
 }
 It "Should return multiple presents with -Count" {
  (Get-myChristmasPresent -count 2).Count | Should be 2
 }
 It "Should return multiple presents with a positional parameter" {
  (Get-myChristmasPresent 2).Count | Should be 2
 }
}

Describe New-Elfname {
 It "Should run without error" {
    {$script:n = New-Elfname } | Should Not Throw
 }

  It "Should return a string" {
    $script:n.GetType().Name | Should Be "String"
 }

 It "Should have a first and last name" {
   $script:n.split().count | Should be 2
 }
}

Describe New-myChristmasGreeting {
 It "Should run without error" {
  {$script:g = New-myChristmasGreeting} | Should Not Throw
 }

  It "Should return a single entry" {
  ($script:g).Count | Should be 1
 }

 It "Should be a string" {
   $script:g.getType().name | Should be "string"
 }
}

}