create table Camera (
    Manufacturer    varchar(30) not null,
    ModelNumber     integer not null,
    ReleaseDate     date not null,
    SensorSize      integer not null,
    PixelNumber     integer not null,
    RetailPrice     float not null
    NumberStock     integer not null,
    primary key ( Manufacturer, ModelNumber )
    foreign key ( Manufacturer, ModelNumber ) 
        references Camera ( Manufacturer, ModelNumber )
)

create table ElectronicViewfinder (
    Manufacturer    varchar(30) not null,
    ModelNumber     integer not null,
    foreign key ( Manufacturer, ModelNumber )
        references Camera ( Manufacturer, ModelNumber )
)

create table OpticalViewfinder (
    Manufacturer    varchar(30) not null,
    ModelNumber     integer not null,
    foreign key ( Manufacturer, ModelNumber )
        references Camera ( Manufacturer, ModelNumber )
)

create table TTLOpticalViewfinder (
    Manufacturer    varchar(30) not null,
    ModelNumber     integer not null,
    foreign key ( Manufacturer, ModelNumber )
        references Camera ( Manufacturer, ModelNumber )
)

create table OpticalRangefinder (
    Manufacturer    varchar(30) not null,
    ModelNumber     integer not null,
    foreign key ( Manufacturer, ModelNumber )
        references Camera ( Manufacturer, ModelNumber )
)

create table Lens (
    Manufacturer    varchar(30) not null,
    ModelNumber     integer not null,
    ReleaseDate     date not null,
    ApertureRange   integer not null,
    RetailPrice     float not null
    NumberStock     integer not null,
    primary key ( Manufacturer, ModelNumber )
)

create table BuiltInCamera (
    Manufacturer    varchar(30) not null,
    ModelNumber     integer not null,
    ApertureRange   float not null,
    primary key ( Manufacturer, ModelNumber ),
    foreign key ( Manufacturer, ModelNumber ) 
        references Camera ( Manufacturer, ModelNumber )
)

create table ReplaceableLensCamera (
    CameraManufacturer  varchar(30) not null,
    CameraModelNumber   integer not null,
    LensManufacturer    varchar(30) not null,
    LensModelNumber     integer not null,    
    primary key ( CameraManufacturer, CameraModelNumber, LensManufacturer, LensModelNumber ),
    foreign key ( CameraManufacturer, CameraModelNumber ) 
        references Camera ( Manufacturer, ModelNumber ),
    foreign key ( LensManufacturer, LensModelNumber )
        references Lens ( Manufacturer, ModelNumber )
)


create table TelescopeLens (
    Manufacturer            varchar(30) not null,
    ModelNumber             integer not null,
    RelevantFoalLengthRange float not null,
    foreign key ( Manufacturer, ModelNumber )
        references Lens ( Manufacturer, ModelNumber )
)

create table PrimeLens (
    Manufacturer     varchar(30) not null,
    ModelNumber      integer not null,
    FocalLength      float not null,
    foreign key ( Manufacturer, ModelNumber )
        references Lens ( Manufacturer, ModelNumber )
)

create table Customer (
    CustomerNumber      integer not null,
    CustomerName        varchar(50) not null,
    EmailAddress        varchar(50) not null,
    ShippingAddress     varchar(70) not null,
    primary key ( CustomerNumber )
)

create table DomesticCustomer (
    CustomerNumber      integer not null,
    primary key ( CustomerNumber ),
    foreign key ( CustomerNumber )
        references Customer ( CustomerNumber )
)

create table ForeignCustomer (
    CustomerNumber      integer not null,
    primary key ( CustomerNumber ),
    foreign key ( CustomerNumber )
        references Customer ( CustomerNumber )
)

create table Order (
    CustomerNumber  integer not null,
    SellingPrice    float not null
    primary key ( CustomerNumber ),
    foreign key ( CustomerNumber )
        references Customer ( CustomerNumber )
)

create table CameraOrder (
    CustomerNumber      integer not null,
    CameraManufacturer  varchar(30) not null,
    CameraModelNumber   integer not null,
    primary key ( CustomerNumber, CameraManufacturer, CameraModelNumber ),
    foreign key ( CustomerNumber )
        references Customer ( CustomerNumber ),
    foreign key ( CameraManufacturer, CameraModelNumber )
        references Customer ( Manufacturer, ModelNumber )
)

create table LensOrder (
    CustomerNumber      integer not null,
    LensManufacturer  varchar(30) not null,
    LensModelNumber   integer not null,
    primary key ( CustomerNumber, LensManufacturer, LensModelNumber ),
    foreign key ( CustomerNumber )
        references Customer ( CustomerNumber ),
    foreign key ( LensManufacturer, LensModelNumber )
        references Lens ( Manufacturer, ModelNumber )
)

create table CameraCustomerEvaluation (
    Score               integer not null,
    Comment             varchar(200) not null,
    CameraManufacturer  varchar(30) not null,
    CameraModelNumber   integer not null,
    primary key ( CameraManufacturer, CameraModelNumber ),
    foreign key ( CameraManufacturer, CameraModelNumber )
        references Camera ( Manufacturer, ModelNumber )
)

create table LensCustomerEvaluation (
    Score               integer not null,
    Comment             varchar(200) not null,
    LensManufacturer  varchar(30) not null,
    LensModelNumber   integer not null,
    primary key ( LensManufacturer, LensModelNumber ),
    foreign key ( LensManufacturer, LensModelNumber )
        references Lens ( Manufacturer, ModelNumber )
)
