

-- Cleaning Data in SQL Queries

Select* 
From PortfolioProjects..Nashville

-- Standardize Date Format

Select SaleDate, CONVERT(date, SaleDate)
From Nashville

Update Nashville
Set SaleDate = CONVERT(date, SaleDate)

Alter Table Nashville
Add SaleDateConverted Date

Update Nashville
Set SaleDateConverted = CONVERT(date, SaleDate)

Select SaleDateConverted, CONVERT(date, SaleDate)
From Nashville

Select SaleDateConverted
From Nashville

-- Populate Property Address Data

Select *
From Nashville
--Where PropertyAddress is null
order by ParcelID 

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
from Nashville a
join Nashville b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from Nashville a
join Nashville b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

--checking above query was successful

select PropertyAddress
from Nashville
where PropertyAddress is null

-- Breaking out Address into Individual Column (Address, City, State)

Select PropertyAddress
from Nashville


Select
SUBSTRING(PropertyAddress, 1,CHARIndex(',', PropertyAddress) -1) as Address,
SUBSTRING(PropertyAddress, CHARIndex(',', PropertyAddress) +1, LEN(PropertyAddress)) as Adderss
from Nashville

Alter Table Nashville
Add PropertySplitAddress nvarchar(255)

Update Nashville
Set PropertySplitAddress= SUBSTRING(PropertyAddress, 1,CHARIndex(',', PropertyAddress) -1)

Alter Table Nashville
Add PropertySplitCIty Nvarchar(255)

Update Nashville
Set PropertySplitCIty = SUBSTRING(PropertyAddress, CHARIndex(',', PropertyAddress) +1, LEN(PropertyAddress))

select*
from Nashville

select OwnerAddress
from Nashville

Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From Nashville

Alter Table Nashville
Add OwnerSplitAddress Nvarchar(255)

update Nashville
set OwnerSplitAddress =PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)

Alter Table Nashville
Add OwnerSplitCIty Nvarchar(255)

update Nashville
set OwnerSplitCity =PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

Alter Table Nashville
Add OwnerSplitState Nvarchar(255)

update Nashville
set OwnerSplitState =PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)

select*
from Nashville

-- Change Y and N to Yes and No in 'SoldAsVacant' field

select Distinct(SoldAsVacant), COUNT(SoldAsVacant)
from Nashville
group by SoldAsVacant
order by 2


select SoldAsVacant
,Case when SoldAsVacant = 'Y' then 'Yes'
	  when SoldAsVacant = 'N' then 'No'
	  Else SoldAsVacant
	  End
from Nashville

update Nashville
set SoldAsVacant = Case when SoldAsVacant = 'Y' then 'Yes'
	  when SoldAsVacant = 'N' then 'No'
	  Else SoldAsVacant
	  End



-- Remove Duplicates



WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From Nashville
--order by ParcelID
)
SELECT*
From RowNumCTE
Where row_num > 1
--Order by PropertyAddress

--Delete Unused Columns



ALTER TABLE Nashville
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE Nashville
DROP COLUMN SaleDate