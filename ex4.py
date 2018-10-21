
# coding: utf-8

# In[4]:


cars = 100 # cars is assigned integer 100
space_in_a_car = 4.0 # space_in_a_car is assigned float 4.0
drivers = 30 # drivers is assigned integer 30
passengers = 90 # passengers is assigned integer 90
cars_not_driven = cars - drivers # cars_not_driven is assigned  cars minus drivers
cars_driven = drivers # cars_driven is assigned drivers
carpool_capacity = cars_driven * space_in_a_car # carpool_capacity is assigned cars_driven multiplied by space_in_a_car
average_passengers_per_car = passengers / cars_driven
# average_passengers_per_car is assigned passengers divided by cars_driven

print("There are", cars, "cars available.")
print("There are only", drivers, "drivers available.")
print("There will be", cars_not_driven, "empty cars today.")
print("We can transport", carpool_capacity, "people today.")
print("We have", passengers, "to carpool today.")
print("We need to put about", average_passengers_per_car,
      "in each car.")


# # car_pool_capacity is not defined because it should not have _ between car and pool

# # Q1,2
We have now an interger value rather than floating number
# In[5]:


space_in_a_car = 4
carpool_capacity = cars_driven * space_in_a_car
carpool_capacity


# # Q3
See above comments