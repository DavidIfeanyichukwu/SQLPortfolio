SELECT * into NashvilleHousing from CovidProject.dbo.NashvilleHousing -- inserted the table in a wrong database, so I used this query to copy the table into my main database

SELECT *
From NashvilleHousing

-- Standardise Date Format
SELECT SaleDate, CONVERT(Date, SaleDate) [Sale Date]
From NashvilleHousing

UPDATE NashvilleHousing
SET SaleDate = CONVERT(Date, SaleDate)

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(Date, SaleDate)

-- Populate Property Address Data
SELECT PropertyAddress
From NashvilleHousing
WHERE PropertyAddress is NULL

SELECT *
From NashvilleHousing


--WHERE PropertyAddress is NULL
ORDER BY ParcelID
 
-- (We will do a self join)
SELECT NashA.ParcelID, NashA.PropertyAddress, NashB.ParcelID, NashB.PropertyAddress, ISNULL(NashA.PropertyAddress, NashB.PropertyAddress) -- 4 this last column will create a new column for us to insert our copied values from where there are existing values into the new column
From NashvilleHousing NashA -- 1 create alias for the 2 tables we want to join, note that we joined this our table to itself, using it's values on both sides of the alias to compare
JOIN NashvilleHousing NashB
On NashA.ParcelID = NashB.ParcelID
AND NashA.UniqueID <> NashB.UniqueID -- 2 if you run from select up to this point, it will display all the properties and also the ones with NULL values
WHERE NashA.PropertyAddress is NULL -- 3 this will filter for only where the propertyaddress is null

-- 5 let's update the new column we have created in 4 above
UPDATE NashA
SET PropertyAddress = ISNULL(NashA.PropertyAddress, NashB.PropertyAddress) -- 8 this tells SQL to update our new column with data that is gotten from where there is data on that column with different uniqueID
FROM NashvilleHousing NashA
JOIN NashvilleHousing NashB
ON NashA.ParcelID = NashB.ParcelID
AND NashA.UniqueID <> NashB.UniqueID -- 6 we use <> to indicate that the uniqueIDs are not the same, meaning that they are different transactions, with the same ParcelID but without PropertyAddress populated
WHERE NashA.PropertyAddress is NULL -- 7 our values is pointing we want to update where the property address is null
-- At this point, run from the select statement to comment number 2 above and you will find out our earstwhile null values are no longer there but have been populated




-- Breaking out individual columns - (address, city, state)
SELECT PropertyAddress
FROM NashvilleHousing
--WHERE PropertyAddress is NULL
--ORDER BY ParcelID

-- (to seperate these we will use substrings)
SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)) [Address]-- using this query to delimit the address up to the the point before the city which is delimited by a ',', we also renamed the column with the square braces
FROM NashvilleHousing

-- To remove the , from the address
SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)) [Address], CHARINDEX(',', PropertyAddress) -- This will give us the total character COUNT in the new entire address column, which we can then subtract 1 character to eliminate the , 
FROM NashvilleHousing

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) [Address]-- subtracting  1 character from every row in the column, now eliminates the ,
FROM NashvilleHousing

-- (We will now put in the city using the same method but still adding a value after the ,)
SELECT PropertyAddress [Property Address],
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) [Address], SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) [City]-- getting the len of propertyaddress 
FROM NashvilleHousing

-- (We will now update the main table with our new query above)
-- first separated column
ALTER TABLE NashvilleHousing
ADD [Separated Property Address] nvarchar(255);

UPDATE NashvilleHousing
SET [Separated Property Address] = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)) 

-- second separated column
ALTER TABLE NashvilleHousing
ADD [Separated Property City] nvarchar(255);

UPDATE NashvilleHousing
SET [Separated Property City] = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))

-----------------------
ALTER TABLE NashvilleHousing
ADD SaleDateConverted Date;

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)
--------------------------
SELECT *
FROM NashvilleHousing

-- Let's now separate the OwnerAddress just like we did for the PropertyAddress
SELECT OwnerAddress
From NashvilleHousing

-- This time we won't use SUBSTRING but we will use PARSENAME ***take note that PARSENAME recognised delimiter is . and not , - so we have to replace the current delimiter to .
SELECT 
PARSENAME(OwnerAddress,1)
from NashvilleHousing

SELECT OwnerAddress,
PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)  -- remember parsename starts counting from right and not left, so it will give us the last values after the '.'
from NashvilleHousing

SELECT OwnerAddress,
PARSENAME(REPLACE(OwnerAddress, ',', '.'),2)  -- specifying 2 gives us the next line of texts after the .
from NashvilleHousing 

SELECT OwnerAddress,
PARSENAME(REPLACE(OwnerAddress, ',', '.'),3)  -- specifying 3 gives us the next line of texts after the .
from NashvilleHousing

-- Now let's combine all the parsename to get our split owner address
SELECT OwnerAddress,
PARSENAME(REPLACE(OwnerAddress, ',', '.'),3) [Separated Owner Address], PARSENAME(REPLACE(OwnerAddress, ',', '.'),2) [Separated Owner City], PARSENAME(REPLACE(OwnerAddress, ',', '.'),1) [Separated Owner State]
from NashvilleHousing

-- Update it to the table
ALTER TABLE NashvilleHousing
ADD [Separated Owner Address] nvarchar(255);

ALTER TABLE NashvilleHousing
ADD [Separated Owner City] nvarchar(255);

ALTER TABLE NashvilleHousing
ADD [Separated Owner State] nvarchar(255);

UPDATE NashvilleHousing
SET [Separated Owner Address] = PARSENAME(REPLACE(OwnerAddress, ',', '.'),3)

UPDATE NashvilleHousing
SET [Separated Owner City] = PARSENAME(REPLACE(OwnerAddress, ',', '.'),2)

UPDATE NashvilleHousing
SET [Separated Owner State] = PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)




------------
--- Looking for null values and how to replace them with values
SELECT DISTINCT ParcelID, PropertyAddress, OwnerName, OwnerAddress
FROM NashvilleHousing
ORDER BY ParcelID DESC

SELECT *
FROM NashvilleHousing

----------------
-- Change the Y and N to Yes and No in the Sold as Vacant column

SELECT SoldAsVacant, COUNT(SoldAsVacant)
FROM NashvilleHousing
GROUP BY SoldAsVacant -- Looking from this statement, we find out the Yes and No are more than the Y and N, so we will replace all the Y and N to Yes and No
ORDER BY 2 DESC

-- We can do this by using the CASE statement

SELECT SoldAsVacant,
    CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
        WHEN SoldAsVacant = 'N' THEN 'No'
        ELSE SoldAsVacant
    END [Sold As Vacant]
FROM NashvilleHousing

-- Now we will update the table, this time without creating new rows, we will update directly into the SoldAsVacant column

Update NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
        WHEN SoldAsVacant = 'N' THEN 'No'
        ELSE SoldAsVacant
    END

-- Remove duplicates
SELECT *
from NashvilleHousing

-- (to get duplicate rows, we use windows function)

SELECT *,
    ROW_NUMBER() OVER (
        PARTITION BY ParcelID,
                     PropertyAddress,
                     SalePrice,
                     SaleDate,
                     LegalReference
                     ORDER BY
                        UniqueID
    ) [Row Number]
From NashvilleHousing
ORDER BY ParcelID -- this entire windows function query gives us a new row stating the number of rows where we can also find out rows with duplicate value 

-- (to use the above, we will insert it into a CTE using the with clause)
WITH [Row Number CTE] AS (
SELECT *,
    ROW_NUMBER() OVER (
        PARTITION BY ParcelID,
                     PropertyAddress,
                     SalePrice,
                     SaleDate,
                     LegalReference
                     ORDER BY
                        UniqueID
    ) [Row Number]
From NashvilleHousing
)
SELECT *
FROM [Row Number CTE]
WHERE [Row Number] > 1 -- to get the just the ones with duplicates
ORDER BY PropertyAddress

-- (after getting the duplicate rows, we will delete them by using the delete command)
WITH [Row Number CTE] AS (
SELECT *,
    ROW_NUMBER() OVER (
        PARTITION BY ParcelID,
                     PropertyAddress,
                     SalePrice,
                     SaleDate,
                     LegalReference
                     ORDER BY
                        UniqueID
    ) [Row Number]
From NashvilleHousing
)
delete
FROM [Row Number CTE]
WHERE [Row Number] > 1 
--ORDER BY PropertyAddress




-- Delete Unused columns
    -- (To do this we will alter the table and delete the desired columns *** Note that the columns we are deleting are the ones that we do not need for any purpose during our visualization)

SELECT *
FROM NashvilleHousing


ALTER TABLE NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate


