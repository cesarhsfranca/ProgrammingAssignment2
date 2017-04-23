## The below code demonstrates the concept of lexical scoping and cache. Scoping is the mechanism within R that determines how
## R finds symbols (i.e. programming language elements, data objects like for example “x” and “m” as well as other data objects
## and functions that can be defined in the body of function, for example) to retrieve their values during the execution of an R script.
##
## Note extracted from https://github.com/lgreski/datasciencectacontent/blob/master/markdown/rprog-lexicalScoping.md:
## “A basic definition of "object" in computing is that an object is a thing that contains state (information), and behavior.
## Another way to describe these concepts is that state represents what an object knows, and behavior represents what an object does.
## These characteristics are implemented in object oriented languages when one writes the code that becomes the template for an
## object that is created when the program code is executed. This template is called a class in many object oriented languages.
## State is implemented as a set of variables or attributes defined within a class, and behavior is implemented as methods or member
## functions within a class.”
## At design / coding time we define classes in code, instantiate (load) them into objects, and instruct the objects to "do things"
## by calling their methods / member functions. The code we write is compiled and saved to disk so it can be executed.
## At program run time, the code is loaded into memory and executed.
##
## In other words Lexical Scoping is used to retrieve values from objects based on the way functions are nested when they were written.
## A cache is a way to store objects in memory to accelerate subsequent access to the same object. In statistics, some matrix algebra
## computations are notoriously expensive in terms of time, such as calculating the inverse of a matrix. Therefore, if one needs to
## use the same inverted matrix for subsequent computations, it is advantageous to cache it in memory instead of repeatedly calculating
## the inverse. 
## The content of the above link basically says:
## “In computing, a cache /ˈkæʃ/ kash,[1] is a hardware or software component that stores data so future requests for that data can be
## served faster; the data stored in a cache might be the result of an earlier computation, or the duplicate of data stored elsewhere.
## A cache hit occurs when the requested data can be found in a cache, while a cache miss occurs when it cannot. Cache hits are served
## by reading data from the cache, which is faster than recomputing a result or reading from a slower data store; thus, the more
## requests can be served from the cache, the faster the system performs.
## To be cost-effective and to enable efficient use of data, caches must be relatively small. Nevertheless, caches have proven
## themselves in many areas of computing because access patterns in typical computer applications exhibit the locality of reference.
## Moreover, access patterns exhibit temporal locality if data is requested again that has been recently requested already, while
## spatial locality refers to requests for data physically stored close to data that has been already requested.”

## Getting back to the purpose of the assignment the below functions are used to cache an inverted matrix as a way of illustrating
## how this might be done with a special matrix object that stores its inverse as an in-memory object instead of recalculate it every
## time its value is needed saving computation time.

## 1.	makeCacheMatrix(): creates a special “matrix” object that can cache its inverse to be used for the next function cacheSolve();

## Note: For the below code and according to the assignment the matrix supplied is always invertible which means its determinant is
## different than zero otherwise its inverse cannot be calculated and an error would be generated (is not the intent of this assignment
## to describe it in more details. Please in the case it is necessary “Google” how to invert a matrix and/or invertible matrix).

## 2.	cacheSolve(): computes the inverse of the special “matrix” created by the function makeCacheMatrix(). Based on that if the
## inverse has been already calculated and not changed the cacheSolve() retrieves the inverse of the matrix from the cache. 
## Here is showed the codes for both functions makeCacheMatrix() and cacheSolve():

## Important: Below the same code is explained in two times, i.e, first in more detail which makes the visualization of the code itself 
## more confused. Second the code is presented with short descriptions which, as oposed to the fist part, helps one to understands
## it more easilly.


## This function makeCacheMatrix() creates a special "matrix" object
## that can cache its inverse.

makeCacheMatrix <- function(x = matrix()) {

## The first thing that occurs in this function is the
## initialization of its objects x and inv.
## Notice that x is initialized as a function argument, a
## formal argument (not a free variable, so
## no further initialization is required within the 
## function. Furthermore, the formals part of the function 
## declaration define the default value of x as a matrix
## (x = matrix()).
## inv is set to NULL, initializing it as an object within the
## makeCacheMatrix() environment to be used by later code in
## the function. Inv is initialized with a default value.
##Initialization of objects with a default value is important
##because without a default value, data <- x$get() generates the ##following error message.
## Error in x$get() : argument "x" is missing, with no default
##
## x is a square invertible matrix.
## This function returns a list containing functions to
##              1. set the matrix
##              2. get the matrix
##              3. set the inverse
##              4. get the inverse
## that are used as the input to the next below function 
## cacheSolve()
        
        inv = NULL
## 
        set = function(y) {

## use `<<-` to assign a value to an object in an environment 
## different from the current environment.                 
## In this function is used the  <<- form of the assignment   
## operator, which assigns the value on the right side of the 
## operator, y and NULL, to an object in the parent environment
## named by the object on the left side of the operator, x and inv
## respectively.
## 
## This function Set() is responsible for assign the input argument   
## to the x object in the parent environment and assign the value of
## NULL to the m object in the parent environment.               
## This line of code clears any value of m that had been cached 
## by a prior execution of makeCacheMatrix ().
      
                x <<- y
                inv <<- NULL
        }

## The below get() function retrieves the x from its parent 
## environment maCacheMatrix().

        get = function() x   
 
## Since inv is defined in a parent environment and it needs to
## be accessed after the execution of set(), the <<- form of the 
## assignment operator is used to assign the inv argument into
## the parent environment.

        setinv = function(inverse) inv <<- inverse 

## Here is defined the getter for the inv where R takes  
## advantage of the Lexical Scoping to find the correct symbol
## inv to retrieve its value.

        getinv = function() inv

## At this moment the getters and setters are defined for both
## of data objects within the function makeCacheMatrix ().
## In the final line of code in the makeCacheMatrix () assigns
## each created function as an element in a list () to be  
## returned to the parent environment.

        list(set=set, get=get, setinv=setinv, getinv=getinv)
}
    
## For the above defined list each element within it is named 
## as:                  
## list(set = set, gives the name “set” to the set() function;
## get = get, gives the name “get” to the get() function; 
## setinv = setinv, gives the name “setinv” to the setinv()
## function;                                  
## getinv = get = inv, gives the name “getinv” to the getinv()
## function.                                              
## The reason to name the list elements is to allow the use of
## the $ form of extract operator in order to access the 
## elements of a list directly by name which makes things less
## confused to understand in the code and also avoiding errors 
## when call the objects.

## The below function cacheSolve(0 completes the whole process
## as it populates or retrieves the inverse from the function  
## makeCacheMatrix(). This function has basically the same   
## structre of the makeCacheMatrix() function in terms of its 
## arguments, x and the “...” argument that is used to pass all
## the additional arguments into the function without the need  
## to copy the entire list of arguments.

cacheSolve <- function(x, ...) {

## @x: output of makeCacheMatrix()
## return: inverse of the original matrix input to
## makeCacheMatrix(). In other words it calls the getinv() 
## function on the inv object. 
        
        inv = x$getinv()
        
## If the inverse has already been calculated which     
## basically means that it checks to see whether the result is 
## NULL. Since the makeCacheMatrix() sets the cached inv to NULL
## whenever a new matrix is set into the object, if the value 
## here is set not equal to NULL, we have a valid, cached  
## matrix inverse that can be returned to the parent     
## environment.

        if (!is.null(inv)){

## get it from the cache and skips the computation. 

                message("getting cached data")
                return(inv)
        }
        
## Otherwise, calculates the inverse. Here is where the
## inverse is calculated thorough execution of the Solve()
## function and this is the reason the function is incomplete 
## without the function cacheSolve(). 

        mat.data = x$get()
        inv = solve(mat.data, ...)
        
## Sets the value of the inverse in the cache via the   
## setinv function.

        x$setinv(inv)
        
        return(inv)
}

## Here is the same code with short descriptions in order for it to be visualized and understood more easilly:

makeCacheMatrix <- function(x = matrix()) {
        ## @x: a square invertible matrix
        ## return: a list containing functions to
        ##              1. set the matrix
        ##              2. get the matrix
        ##              3. set the inverse
        ##              4. get the inverse
        ##         this list is used as the input to cacheSolve()
        
        inv = NULL
        set = function(y) {
                # use `<<-` to assign a value to an object in an environment 
                # different from the current environment. 
                x <<- y
                inv <<- NULL
        }
        get = function() x
        setinv = function(inverse) inv <<- inverse 
        getinv = function() inv
        list(set=set, get=get, setinv=setinv, getinv=getinv)
}

cacheSolve <- function(x, ...) {
        ## @x: output of makeCacheMatrix()
        ## return: inverse of the original matrix input to makeCacheMatrix()
        
        inv = x$getinv()
        
        # if the inverse has already been calculated
        if (!is.null(inv)){
                # get it from the cache and skips the computation. 
                message("getting cached data")
                return(inv)
        }
        
        # otherwise, calculates the inverse 
        mat.data = x$get()
        inv = solve(mat.data, ...)
        
        # sets the value of the inverse in the cache via the setinv function.
        x$setinv(inv)
        
        return(inv)
}
