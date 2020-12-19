# SDQ-Commons

This repository contains commons projects providing utility functionality that is not project-specific.

Install from [update site](https://kit-sdq.github.io/updatesite/release/commons) (only for use via "Install Software" in Eclipse)

## Project Development

The commons projects in this repository are developed and intended to be used by members of the Chair for Software Design and Quality (SDQ) at the Karlsruhe Institute of Technology (KIT): http://sdq.ipd.kit.edu/

## Project and Implementation Structure

* Each project is specific for one domain, e.g. Java or EMF and should be named edu.kit.ipd.sdq.commons.util.$domainname.
That is, the name of the root folder and plug-in for utility functionality for the domain "ABC" would be "edu.kit.ipd.sdq.commons.util.abc".
* Each utility class within these projects is supposed to define utility functions for one domain class and shall be named just as the domain class followed by "Util".
For example, the utilites class for the domain class "EObject" shall be called "EObjectUtil".
* Each utility function within such a class should be static and accept an object of the domain class it is defined for as the first argument.

The last point is necessary because the utilites are intended to be used in Xtend code. Xtend provides an import mechanism for so called
"static extensions", which allows it to call static methods of the imported class on objects that are instances of the first parameter type just like if they were defined in that type. 
