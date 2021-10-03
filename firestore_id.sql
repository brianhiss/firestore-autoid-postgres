/*
	Create Firestore AutoId Function in Postgres from firebase-js-sdk
  Reference: https://github.com/firebase/firebase-js-sdk/blob/4090271bb71023c3e6587d8bd8315ebf99b3ccd7/packages/firestore/src/util/misc.ts
*/

-- Install pgcrypto extension
CREATE extension IF NOT EXISTS pgcrypto;

-- Create function
CREATE OR REPLACE FUNCTION firestore_id()
 RETURNS TEXT
 LANGUAGE plpgsql
AS $function$
DECLARE
	chars TEXT := 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
	max_multiple INTEGER := FLOOR(256 / LENGTH(chars)) * LENGTH(chars);
	target_length INTEGER := 20;
	auto_id TEXT := '';
	bytes BYTEA;
BEGIN

	while LENGTH(auto_id) < target_length loop
		bytes := gen_random_bytes(40);

		for i in 0..LENGTH(bytes) - 1 loop
			-- Only accept values that are [0, maxMultiple), this ensures they can
		  -- be evenly mapped to indices of `chars` via a modulo operation.
			if (LENGTH(auto_id) < target_length AND get_byte(bytes, i) < max_multiple) then
			  auto_id := auto_id || SUBSTRING( chars, (get_byte(bytes, i) % LENGTH(chars)) + 1, 1);
			end if;

	  end loop;
			
	end loop;

	RETURN auto_id; 
END
$function$;