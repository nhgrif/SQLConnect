/*
 The MIT License (MIT)
 
 Copyright (c) 2015 Nick Griffith
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

typedef NS_ENUM (NSInteger, SQLErrorCodes) {
    SQL_LoginStructFailedToInitialize = 100,
    SQL_ConnectionError = 101,
    SQL_DatabaseChangeError = 102,
    SQL_ExecutionError = 200,
    SQL_ColumnsStructFailedToInitialize = 201,
    SQL_BufferFailedToAllocate = 202,
    SQL_ErrorBindingColumnName = 203,
    SQL_ErrorBindingColumnStatus = 204,
    SQL_BufferFull = 205,
    SQL_RowReadError = 206
};

#define kSQL_LoginStructFailedToInitialize  (@"Login struct failed to initialize")
#define kSQL_ConnectionError                (@"An error occurred while attempting to connect to the server")
#define kSQL_DatabaseChangeError            (@"An error occurred while attempting to change databases")
#define kSQL_ExecutionError                 (@"An error occurred while attempting to execute the SQL statement")
#define kSQL_ColumnStructFailedToInitialize (@"Column struct failed to initialize")
#define kSQL_BufferFailedToAllocate         (@"Data buffer failed to allocate")
#define kSQL_ErrorBindingColumnName         (@"An error occurred while attempting to bind a column name")
#define kSQL_ErrorBindingColumnStatus       (@"An error occurred while attempting to bind a column status")
#define kSQL_BufferFull                     (@"Buffer full")
#define kSQL_RowReadError                   (@"An error occurred while attempting to read a row")