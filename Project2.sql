Select *
From Project2..Nashville


-- Standard Date Format

Select *
From Project2..Nashville

Alter Table Nashville
Add SaleDateConverted Date;

Update Nashville
Set SaleDateConverted = Convert(Date,SaleDate)

Select SaleDateConverted, Convert(Date,SaleDate)
From Project2..Nashville


-- Populate Property Address Data
Select *
From Project2..Nashville
--Where PropertyAddress is not Null
order by ParcelID


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From Project2..Nashville a
Join Project2..Nashville b
	On a.ParcelID = b.ParcelID
	And a.[UniqueID ] <> b. [UniqueID ]
Where a.PropertyAddress is null

Update a 
Set PropertyAddress = ISNULL (a.PropertyAddress, b.PropertyAddress)
From Project2..Nashville a
Join Project2..Nashville b
	On a.ParcelID = b.ParcelID
	And a.[UniqueID ] <> b. [UniqueID ]
where a.PropertyAddress is null


-- Breaking out into Individual Columns (Address, city, State)

Select PropertyAddress
From Project2..Nashville

Select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1) as Address, 
SUBSTRING (PropertyAddress, CHARINDEX(',', PropertyAddress) +1, Len(PropertyAddress)) as Address


From Project2..Nashville

Alter Table Nashville
Add PropertysplitAddress Nvarchar(255);

Update Nashville
Set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1)  

Alter Table Nashville
Add PropertySplitCity Nvarchar (255) ;

Update Nashville
Set PropertySplitCity = SUBSTRING (PropertyAddress, CHARINDEX(',', PropertyAddress) +1, Len(PropertyAddress))

Select *
From Nashville


-- 
Select OwnerAddress
From Nashville


Select 
PARSENAME (Replace(OwnerAddress,',','.'),3),
PARSENAME (Replace(OwnerAddress,',','.'),2),
PARSENAME (Replace(OwnerAddress,',','.'),1)
From Nashville


Alter Table Nashville
Add OwnersplitAddress Nvarchar(255);

Update Nashville
Set OwnersplitAddress = PARSENAME (Replace(OwnerAddress,',','.'),3)

Alter Table Nashville
Add OwnersplitCity Nvarchar(255);

Update Nashville
Set OwnersplitCity = PARSENAME (Replace(OwnerAddress,',','.'),2)

Alter Table Nashville
Add OwnersplitState Nvarchar(255);

Update Nashville
Set OwnersplitState = PARSENAME (Replace(OwnerAddress,',','.'),1)

Select *
From Project2..Nashville


-- Change Y and N to Yes and No in "Sold as Vacant" field

Select Distinct(SoldAsVacant), count (SoldAsVacant)
From Nashville
Group by SoldAsVacant
order by 2

Select SoldAsVacant,
Case when SoldAsVacant = 'Y' Then 'Yes'
	when SoldAsVacant = 'n' Then 'No'
	Else SoldAsVacant
	End

From Nashville

Update Nashville
Set SoldAsVacant =Case when SoldAsVacant = 'Y' Then 'Yes'
	when SoldAsVacant = 'n' Then 'No'
	Else SoldAsVacant
	End


-- Delete Dupe column

With RowNumCTE as (
Select *, 
	ROW_NUMBER() over (
	Partition by ParcelID,
				PropertyAddress,
				SaleDate,
				LegalReference
				Order by 
					UniqueID
				) row_num

From Project2.dbo.Nashville 
)
--Delete
Select *
From RowNumCTE
where row_num > 1
--order by PropertyAddress

-- Delete the unused olumn

 

Alter Table Project2.dbo.Nashville
Drop Column OwnerAddress, TaxDistrict, PropertyAddress

Alter Table Project2.dbo.Nashville
Drop Column SaleDate


