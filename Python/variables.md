# Variables basics

## Variables
Variables store values. Example:

```python
name = "Pelumi"
print(name)
```
Output: Pelumi


## Naming Conventions
- Use snake_case for variable names: first_name
- Do not use spaces; use _ instead
- More on snake case: What is Snake Case?

## Data Types

### String
Text wrapped in quotes (" or '). Prefer double quotes for consistency.

```python
name = "Pelumi"
```

### Integer
Whole numbers, positive or negative, without quotes.

```python
age = 5
print(age)
```
Output: 5

### Float
Numbers with decimal points.

```python
height = 5.9
print(height)
```
Output: 5.9

### Boolean
Represents True or False.

```python
married = True
print(married)
```
Output: True

## Concatenation
Combining strings with + or commas:

```python
first_name = "Pelumi"
last_name = "Babatunde"
```
- Using +
```python
full_name = first_name + " " + last_name
print(full_name)
```
Output: Pelumi Babatunde

## Using commas in print
```python
print(first_name, last_name)
```
Output: Pelumi Babatunde

## f-Strings (Formatted Strings)
Easier way to embed variables inside strings using f"":

```python
name = "Pelumi"
level = 5
character_class = "Mage"

print(f"{name} is a level {level} {character_class}.")
```
Output: Pelumi is a level 5 Mage.
