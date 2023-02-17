
select *
from PortfolioProjects..NashvilleHousing
-- Standardize Date Format
select *
from PortfolioProjects..NashvilleHousing

alter table NashvilleHousing 
add SaleDateConverted Date

update NashvilleHousing
set SaleDateConverted = CONVERT(date, SaleDate)

alter table NashvilleHousing alter column SaleDate Date

--Populate Property Address data

select *
from PortfolioProjects..NashvilleHousing
--where PropertyAddress is null
order by 2

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.PropertyAddress,b.PropertyAddress)
from PortfolioProjects..NashvilleHousing a
join PortfolioProjects..NashvilleHousing b
 on a.ParcelID = b.ParcelID
 and a.UniqueID <> b.UniqueID
 where a.PropertyAddress is null

 update a
 set PropertyAddress = isnull(a.PropertyAddress,b.PropertyAddress)
 from PortfolioProjects..NashvilleHousing a
join PortfolioProjects..NashvilleHousing b
 on a.ParcelID = b.ParcelID
 and a.UniqueID <> b.UniqueID

 --Breaking out Address into Individual Columns (Address, City, State)

 select PropertyAddress
 from PortfolioProjects..NashvilleHousing

 select 
 SUBSTRING(PropertyAddress,1,charindex(',',PropertyAddress) - 1) as Address,
 SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress) + 1, len(PropertyAddress)) as City
 from PortfolioProjects..NashvilleHousing

 alter table NashvilleHousing
 add PropertyAddressSplitAddress nvarchar(255)

 update NashvilleHousing
 set PropertyAddressSplitAddress = SUBSTRING(PropertyAddress,1,charindex(',',PropertyAddress) - 1)

 alter table NashvilleHousing
 add PropertyAddressSplitCity nvarchar(255)

 update NashvilleHousing
 set PropertyAddressSplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress) + 1, len(PropertyAddress))

 select OwnerAddress
 from PortfolioProjects..NashvilleHousing
 --where OwnerAddress is null

 select 
 PARSENAME(replace(OwnerAddress,',','.'),3),
 PARSENAME(replace(OwnerAddress,',','.'),2),
 PARSENAME(replace(OwnerAddress,',','.'),1)
 from PortfolioProjects..NashvilleHousing
 
 alter table NashvilleHousing
 add OwnerSplitAddress nvarchar(255)

 update NashvilleHousing
 set OwnerSplitAddress = PARSENAME(replace(OwnerAddress,',','.'),3)

  alter table NashvilleHousing
 add OwnerSplitCity nvarchar(255)

 update NashvilleHousing
 set OwnerSplitCity = PARSENAME(replace(OwnerAddress,',','.'),2)

   alter table NashvilleHousing
 add OwnerSplitState nvarchar(255)

 update NashvilleHousing
 set OwnerSplitState = PARSENAME(replace(OwnerAddress,',','.'),1)

 select *
 from PortfolioProjects..NashvilleHousing

 -- Change Y and N to Yes and No in "Sold as Vascant" field
 
 select distinct(SoldAsVacant),count(SoldAsVacant)
 from PortfolioProjects..NashvilleHousing
 group by SoldAsVacant
 order by 2

select SoldAsVacant
 , case when SoldAsVacant = 'Y' then 'Yes'
        when SoldAsVacant = 'N' then 'No'
		else SoldAsVacant
		end
from PortfolioProjects..NashvilleHousing

update NashvilleHousing
set  SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
        when SoldAsVacant = 'N' then 'No'
		else SoldAsVacant
		end

-- Removing Duplicates

with RowNumCTE as
(
 select *,
     ROW_NUMBER() over (
                       partition by ParcelID, 
					                PropertyAddress, 
									SalePrice, 
									SaleDate, 
									LegalReference 
									order by UniqueID ) as row_num
 from PortfolioProjects..NashvilleHousing
 )
 select *
 from RowNumCTE
 where row_num > 1
--order by PropertyAddress


--Delete Unused Columns

select *
from PortfolioProjects..NashvilleHousing

create view RevisedTable as

alter table NashvilleHousing
drop column PropertyAddress, SaleDate, OwnerAddress, TaxDistrict











