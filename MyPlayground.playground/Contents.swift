//: Playground - noun: a place where people can play

import UIKit

//Code Challenge: Write a function that determines how many words there are in a sentence

var sentence = "Regardless of where you start the fun, you’ll cruise the Seattle Waterfront to see the Seattle Aquarium, the Great Wheel and where the Alaskan Gold Rush first started."

func wordCounter(sentence: String) -> Int {
  
  let sentenceArray = Array(sentence)
  var words = 1
  
  for letter in sentence {
    if letter == " " {
      words++
    }
  }
  return words
}

wordCounter(sentence)

//Code Challenge: Write a function that returns all the odd elements of an array
var numberLine = [233, 224, 75, 96, 39, 11, 13]

func returnOdds(array:[Int]) -> [Int] {
  var oddsArray = [Int]()
  let arrayLength = array.count
  var i = 0
  
  for (i = 0; i < arrayLength; i++) {
    if i % 2 != 0 {
      println("item is odd!")
      let oddNumber = array[i]
      oddsArray.append(oddNumber)
    }
  }
  return oddsArray
}

returnOdds(numberLine)


//Code Challenge: Write a function that computes the list of the first 100 Fibonacci numbers.

//let fibonacciArray = [int]()
//
//func findFibonacciSeq(arrayLength: Int) -> [Int] {
//  var i = 0
//  var fibonacciArray[i] = a
//  var fibonacciArray[i] = b
//  
//  
//  
//}





//Code Challenge: Write a function that tests whether a string is a palindrome

func isItAPalindrome(word: String) {
  
  let wordAsArray = Array(word)
  let reverseWordAsArray = wordAsArray.reverse()
  
  if wordAsArray == reverseWordAsArray {
    println("This is a palindrome")
  } else {
    println("This is NOT a palindrome")
  }
}

isItAPalindrome("radar")
isItAPalindrome("cheetos")


//Implement a stack (LIFO)

let stackArray = [AnyObject]()

func makeAStack(object:AnyObject) -> [AnyObject] {
  
  
}















