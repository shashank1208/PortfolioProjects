SELECT * FROM protfolioproject.`nashville housing`;

------------------------------------------------------------------------

-- Standardize Date Format

select SaleDate From protfolioproject.`nashville housing`;

update protfolioproject.`nashville housing`
set SaleDate=str_to_date(SaleDate,"%M %d, %Y"); 

--------------------------------------------------------------------------------------------

-- Populate Property Address date

select * from protfolioproject.`nashville housing`
-- where PropertyAddress is null or PropertyAddress=''
order by  ParcelID;

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
From protfolioproject.`nashville housing` a
join protfolioproject.`nashville housing` b
    on a.ParcelID = b.ParcelID
    and a.UniqueID <> b.UniqueID
    where a.PropertyAddress = '';

delete from protfolioproject.`nashville housing`
where PropertyAddress = '';

-------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)

select PropertyAddress 
from protfolioproject.`nashville housing`;
-- where PropertyAddress is null or PropertyAddress=''
-- order by  ParcelID;

Select 
substr(PropertyAddress, 1, instr(PropertyAddress, ',') -1) as Address,
substr(PropertyAddress, instr(PropertyAddress, ',') +1) as Address
From protfolioproject.`nashville housing`;

alter table protfolioproject.`nashville housing`
add PropertySplitAddress varchar(255);

update protfolioproject.`nashville housing`
set PropertySplitAddress = substr(PropertyAddress, 1, instr(PropertyAddress, ',') -1);

alter table protfolioproject.`nashville housing`
add PropertySplitCity varchar(255);

update protfolioproject.`nashville housing`
set PropertySplitCity = substr(PropertyAddress, instr(PropertyAddress, ',') +1);

SELECT * FROM protfolioproject.`nashville housing`;


SELECT OwnerAddress FROM protfolioproject.`nashville housing`;

select 
substring_index(OwnerAddress,',',1),
substring_index(substring_index(OwnerAddress,',',2), ',', -1),
substring_index(OwnerAddress,',',-1)
FROM protfolioproject.`nashville housing`;


alter table protfolioproject.`nashville housing`
add OwnerSplitAddress varchar(255);

update protfolioproject.`nashville housing`
set OwnerSplitAddress = substring_index(OwnerAddress,',',1);

alter table protfolioproject.`nashville housing`
add OwnerSplitCity varchar(255);

update protfolioproject.`nashville housing`
set OwnerSplitCity = substring_index(substring_index(OwnerAddress,',',2), ',', -1);

alter table protfolioproject.`nashville housing`
add OwnerSplitState varchar(255);

update protfolioproject.`nashville housing`
set OwnerSplitState = substring_index(OwnerAddress,',',-1);

SELECT * FROM protfolioproject.`nashville housing`;


---------------------------------------------------------------------------------------------------------

-- Change Y and N to Yes and No In SoldAsVacant Field

select distinct(SoldASVacant), count(SoldASVacant)
FROM protfolioproject.`nashville housing`
group by SoldAsVacant
order by 2;

select SoldAsVacant,
case 
     when SoldAsVacant = 'Y' then 'Yes'
	 when SoldAsVacant = 'N' then 'No'
	 else SoldAsVacant
     end
 FROM protfolioproject.`nashville housing`;   
 
 UPDATE protfolioproject.`nashville housing` 
SET 
    SoldASVacant = CASE
        WHEN SoldAsVacant = 'Y' THEN 'Yes'
        WHEN SoldAsVacant = 'N' THEN 'No'
        ELSE SoldAsVacant
    END;
    
------------------------------------------------------------------------------------------------------------------------------------------
    
-- Remove Duplicates

select
      ParcelID, count(ParcelID),
	  PropertyAddress, count(PropertyAddress),
	  SalePrice, count(SalePrice),
	  SaleDate, count(SaleDate),
	  LegalReference, count(LegalReference)
FROM protfolioproject.`nashville housing`
group by ParcelID,
		PropertyAddress,
		SalePrice,
		SaleDate,
		LegalReference
having  count(ParcelID) > 1
	  and count(PropertyAddress) >1
	  and count(SalePrice) > 1
	  and count(SaleDate) > 1
	  and count(LegalReference);     


DELETE t1 FROM protfolioproject.`nashville housing` t1
INNER JOIN protfolioproject.`nashville housing` t2 
WHERE 
    t1.UniqueID < t2.UniqueID AND 
    t1.ParcelID = t2.ParcelID;


---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns

select *
FROM protfolioproject.`nashville housing`;

alter table protfolioproject.`nashville housing`
drop column OwnerAddress,
drop column TaxDistrict,
drop column PropertyAddress,
drop column SaleDate; 












     

