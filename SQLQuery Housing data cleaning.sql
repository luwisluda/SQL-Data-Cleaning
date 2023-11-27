---CLEARING DATA IN SQL QUIRIES
SELECT *
FROM PortfolioProject1..NashvilleHousing

--STANDARDISE DATE FOREST
SELECT saleDate,CONVERT(Date,SaleDate) as CLeanedDate
FROM PortfolioProject1..NashvilleHousing

UPDATE PortfolioProject1..NashvilleHousing
SET SaleDate=Convert(Date,SaleDate)

ALTER TABLE PortfolioProject1..NashvilleHousing
ADD SaleDate2 Date;

UPDATE PortfolioProject1..NashvilleHousing
SET SaleDate2 = Convert(Date,SaleDate)
--------------------------------------------------------------------

---(filling in null values)  POPULATE PROPERTY ADDRESS DATA.
SELECT [UniqueID ],ParcelID,PropertyAddress
FROM PortfolioProject1..NashvilleHousing
WHERE PropertyAddress is Null


SELECT a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress
      ,ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM PortfolioProject1..NashvilleHousing a
JOIN PortfolioProject1..NashvilleHousing b
  ON a.ParcelID= b.ParcelID
  AND a.[UniqueID ]<>b.[UniqueID ]
  where a.PropertyAddress is null

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM PortfolioProject1..NashvilleHousing a
JOIN PortfolioProject1..NashvilleHousing b
  ON a.ParcelID= b.ParcelID
  AND a.[UniqueID ]<>b.[UniqueID ]
  where a.PropertyAddress is null
  -----------------------------------------------------------------

  ---BREAKING out PROPERTYADDRESS column into indivdual Columns (Address, City, State) 
SELECT PropertyAddress, SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress,1)-1) as ADDRESS
         ,SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress,1)+1,LEN(PropertyAddress) )as City
FROM PortfolioProject1..NashvilleHousing

ALTER TABLE  PortfolioProject1.dbo.NashvilleHousing
ADD PropertySplitADDRESS NVARCHAR(255)

UPDATE PortfolioProject1.dbo.NashvilleHousing
SET PropertySplitADDRESS=SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress,1)-1)


ALTER TABLE  PortfolioProject1.dbo.NashvilleHousing
ADD PropertySplitCITY NVARCHAR(255)

UPDATE PortfolioProject1.dbo.NashvilleHousing
SET PropertySplitCITY=SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress,1)+1,LEN(PropertyAddress))
------------------------------------------------------------------------------------

---BREAKING out OWNER ADDRESS column into indivdual Columns (Address, City, State)
SELECT OwnerAddress,PARSENAME(REPLACE(OwnerAddress,',','.'),3) as ADDRESS
     ,PARSENAME(REPLACE(OwnerAddress,',','.'),2) as CITY
      ,PARSENAME(REPLACE(OwnerAddress,',','.'),1) as STATE
FROM PortfolioProject1.dbo.NashvilleHousing

ALTER TABLE  PortfolioProject1.dbo.NashvilleHousing
ADD OWNERSplitADDRESS NVARCHAR(255)

UPDATE PortfolioProject1.dbo.NashvilleHousing
SET OWNERSplitADDRESS =PARSENAME(REPLACE(OwnerAddress,',','.'),3)

ALTER TABLE  PortfolioProject1.dbo.NashvilleHousing
ADD OWNERSplitCITY NVARCHAR(255)

UPDATE PortfolioProject1.dbo.NashvilleHousing
SET OWNERSplitCITY =PARSENAME(REPLACE(OwnerAddress,',','.'),2) 

ALTER TABLE  PortfolioProject1.dbo.NashvilleHousing
ADD PropertySplitSTATE NVARCHAR(255)

UPDATE PortfolioProject1.dbo.NashvilleHousing
SET PropertySplitSTATE =PARSENAME(REPLACE(OwnerAddress,',','.'),1) 
-------------------------------------------------------------------------

--CHANING 'Y' and 'N' to 'Yes' and 'No' in SoldAsVacant Column;
SELECT DISTINCT(SoldAsVacant),COUNT(SoldAsVacant) as numberSold
 ,CASE
     WHEN SoldAsVacant= 'N' then 'No'
      when SoldAsVacant= 'Y' then 'Yes'
      Else SoldAsVacant
  END as SOLDYesNo
FROM PortfolioProject1..NashvilleHousing
Group By SoldAsVacant

UPDATE PortfolioProject1..NashvilleHousing
SET SoldAsVacant=CASE
                    WHEN SoldAsVacant= 'N' then 'No'
                    WHen SoldAsVacant= 'Y' then 'Yes'
                    Else SoldAsVacant
                 END
FROM PortfolioProject1..NashvilleHousing
--------------------------------------------------------

 ---REMOVING DUPLICATEs---
 WITH DupCTE as
 ( 
 SELECT *, ROW_NUMBER() OVER (Partition BY 
		                      ParcelID,
							  PropertyAddress,
							  SaleDate2,
							  SalePrice,
							  LegalReference
		                      ORDER BY UniqueID
							  ) as Duplicates
  FROM PortfolioProject1..NashvilleHousing
 )
 
DELETE
FROM DupCTE
WHERE Duplicates>1 
-----------------------------

-----DELETING UNUSED Columns---
 select*
 from PortfolioProject1..NashvilleHousing

 ALTER TABLE PortfolioProject1..NashvilleHousing
 DROP COLUMN PropertyAddress,SaleDate,OwnerAddress,TaxDistrict  



