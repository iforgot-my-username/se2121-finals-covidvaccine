# se2121-finals-covidvaccine
## Submitted By:
* Paul Vincent Garibay
* BSSE-2

## What have I done?
What did I do? What took the most of my time was self-studying and finding documentation and notes that I could understand, as well as deciding how to process the data or what the proper process was.


* **3.1** -> I use the `INSERT INTO` and instead of `VALUES` I derectly use the `SELECT` query to insert the values. But since some of the date are duplicates to get rid of I use the `ON CONFLICT ()` to handle them and sine the duplicates are not needed I use the `DO NOTHING`key word.

* **3.2** -> Here I use the `FOR` **loop** in order to add all the vaccines and make it as a single `TEXT` **variable or column**.

* **3.3** -> In this one I use the `UPDATE SET` and maked the variables in `WHERE` clause lower case to lessen bugs and headaches.

* **5** -> I made a `TEMPORARY TABLE` for this items to group and remove duplicate or unnesesary items, in a more efficiently way by using the `INSER INTO` clause and utilizing the `ON CONFLICT DO` clause. In this Items I also used `FOR` loops.

* **6** -> Made a `VIEWS` containing the daily average vaccinations per iso_code per vaccines, by using `INNER JOIN` too the location and vbm tables and also using the function `AVG()` and aggregation.
