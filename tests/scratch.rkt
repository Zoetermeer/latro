#lang at-exp racket

(require "common.rkt"
         rackunit)

@infix-reordered{                       
  fun ||(True, _) = True       
  fun ||(_, True) = True       
  fun ||(_, _) = False         
                               
  //XOR                        
  fun !!(False, False) = False 
  fun !!(True, True) = False   
  fun !!(_, _) = True          
                               
  precedence || 1              
  precedence !! 2              
                               
  True !! True || True         
}                              