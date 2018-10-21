
# coding: utf-8

# # Q1: Comment

# In[9]:


print("I will now count my chickens:") # print a string 

print("Hens", 25 + 30 / 6) # print a string and float 25 + 5 = 30
print("Roosters", 100 - 25 * 3 % 4)  # print a string and integer 100 - (75 mod 4) = 100 - 3 

print("Now I will count the eggs:") # print a string

print(3 + 2 + 1 - 5 + 4 % 2 - 1 / 4 + 6) # print float number  1 + (4 mod 2) -0.25 + 6 = 6.75

print("Is it true that 3 + 2 < 5 - 7?") # print a string

print(3 + 2 < 5 - 7) # 5 < -2 is false , then print false (both sides are integers)

print("What is 3 + 2?", 3 + 2) # print a string and integer 5
print("What is 5 - 7?", 5 - 7) # print a string and integer -2

print("Oh, that's why it's False.") # print a string

print("How about some more.") # print a string

# both sides of operations are integers 
print("Is it greater?", 5 > -2) # print a string and true
print("Is it greater or equal?", 5 >= -2) # print a string and true
print("Is it less or equal?", 5 <= -2) # print a string and false


# # Q2,Q3

# In[12]:


sum([1,2,3,4,5])


# # Q4: Float

# In[10]:


print("I will now count my chickens:") 

print("Hens", 25 + 30 / 6) # already float
print("Roosters", float(100 - 25 * 3 % 4)) 

print("Now I will count the eggs:") 

print(3 + 2 + 1 - 5 + 4 % 2 - 1 / 4 + 6) # already float

print("Is it true that 3 + 2 < 5 - 7?") 

print(float(3 + 2) < float(5 - 7)) 

print("What is 3 + 2?", float(3 + 2)) 
print("What is 5 - 7?", float(5 - 7))

print("Oh, that's why it's False.")

print("How about some more.")

print("Is it greater?", float(5) > float(-2)) 
print("Is it greater or equal?", float(5) >= float(-2)) 
print("Is it less or equal?", float(5) <= float(-2)) 

