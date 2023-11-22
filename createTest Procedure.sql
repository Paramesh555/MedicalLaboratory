DELIMITER &&
CREATE PROCEDURE create_order(IN PatientId INT,IN date DATE,IN Doctor_Id INT)
BEGIN
	INSERT INTO Orders (dateOrdered, status, totalCost, patientId,doctorId) VALUES (date, 'PENDING',0, PatientId,Doctor_Id);
	
END&&
DELIMITER ; 


DELIMITER &&
CREATE PROCEDURE create_order_test(IN OrderId INT,IN TestId int)
BEGIN
	INSERT INTO test_order (orderId,testId) VALUES (OrderId,TestId);
END&&
DELIMITER ;


DELIMITER &&
CREATE PROCEDURE get_cost_update(IN orderIdVar INT)
BEGIN
	DECLARE totalCostVar INT;
	select SUM(price) INTO totalCostVar from test where testId IN (
	select testId from test_order where orderId = orderIdVar);

	Update orders SET totalCost = totalCostVar where orderId = orderIdVar;

END&&
DELIMITER ;


CREATE TABLE DelayedTasks (
    task_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL, 
    scheduled_time TIMESTAMP NOT NULL,
    executed BOOLEAN DEFAULT 0 
);


DELIMITER &&
CREATE TRIGGER insert_delayed_task
AFTER INSERT ON Orders
FOR EACH ROW
BEGIN
    SET @scheduled_time = NOW() + INTERVAL 1 HOUR;
    INSERT INTO DelayedTasks (order_id, scheduled_time) VALUES (NEW.orderId, @scheduled_time);
END&&
DELIMITER ;



--creating event
DELIMITER $$
CREATE EVENT IF NOT EXISTS process_delayed_tasks
ON SCHEDULE EVERY 10 MINUTE -- Adjust as needed
DO
BEGIN

    -- making executed as 1 
    UPDATE DelayedTasks
    SET executed = 1
    WHERE scheduled_time <= NOW()
    AND executed = 0;
    
    -- inserting the values into the report table
    INSERT INTO  Report (result,testId,doctorId,patientId)
	SELECT 'NORMAL',testId,doctorId,patientId
	FROM test_order left join orders on test_order.orderId = orders.orderId
	WHERE test_order.orderId IN (SELECT order_id FROM DelayedTasks WHERE  executed = 1);
	--updating the orders table
    update orders set status = 'DONE' where orderId IN (SELECT order_id from DelayedTasks where executed =1);
    -- deleting the executed task from the dealy table
    DELETE FROM DelayedTasks WHERE executed = 1;
END$$
DELIMITER ;



DELIMITER $$

--to know he paid or not
CREATE FUNCTION check_payment(patient_id_param INT)
RETURNS BOOLEAN
READS SQL DATA
BEGIN
    DECLARE is_exists BOOLEAN;

    -- Check if the patient ID exists in the report table
    SELECT EXISTS (
        SELECT 1
        FROM payment
        WHERE orderId in (select orderId from orders where patientId = patient_id_param)
    ) INTO is_exists;

    -- Return TRUE if the patient ID exists, otherwise return FALSE
    RETURN is_exists;
END$$

DELIMITER ;


DELIMITER $$

CREATE FUNCTION check_amount(patient_id_param INT)
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE amount INT DEFAULT 0; 
    
    
    SELECT totalCost INTO amount
    FROM orders
    WHERE patientId = patient_id_param
    LIMIT 1; 
    
    -
    RETURN amount;
END$$

DELIMITER ;










