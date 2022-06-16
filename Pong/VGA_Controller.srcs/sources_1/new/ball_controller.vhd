--- Syntax Error File als Notiz


--IF (((x > ball_x - BALL_RADIUS) AND (y > ball_y - BALL_RADIUS) AND (x < ball_x + BALL_RADIUS) AND (y < ball_y + BALL_RADIUS))) THEN
--                red_pong <= "1111";
--                green_pong <= "1111";
--                blue_pong <= "1111";
--            END IF;

--                --IF (BTNC = '1') THEN
--                --    ball_dx <= 1;
--                --    ball_dy <= -1;
--                --END IF;
                
--                -- Collision Detection. Noch sehr simplifiziert, da mir keine bessere bugfreie idee gekommen ist.
--                -- Kollision wird nur auf der Ebene der inneren Paddelkante überprüft. Der Ball kann somit nicht von oben oder unten mit dem Paddel kollidieren.

--                -- ELSIF hier benötigt, um die Test in Sequentiellem ablauf durchzugehen. Wir wollen den Ball entweder bewegen oder zurücksetzen.

--                -- Abfrage ob Wand Links berühr wird
--                IF (ball_x < BALL_RADIUS + PADDLE_WIDTH + PADDLE_WALL_DIST) THEN
--                    -- Abfrage ob Wand an der Stelle des Paddels berührt wird
--                    IF (ball_y > (paddleL_y + BALL_RADIUS) AND ball_y < (paddleL_y - BALL_RADIUS + PADDLE_HEIGHT)) THEN
--                        ball_dx <= 1;
--                        ball_x <= ball_x + ball_dx;
--                        ball_y <= ball_y + ball_dy;
--                    ELSE
--                        ball_x <= 640/2;
--                        ball_y <= 480/2;
--                    END IF;

--                -- Abfrage ob Wand Rechts berührt wird
--                ELSIF (ball_x > (640 - BALL_RADIUS - PADDLE_WIDTH - PADDLE_WALL_DIST)) THEN
--                    -- Abfrage ob Wand an der Stelle des Paddels berührt wird
--                    IF (ball_y > (paddleR_y + BALL_RADIUS) AND ball_y < (paddleR_y - BALL_RADIUS + PADDLE_HEIGHT)) THEN
--                        ball_dx <= - 1;
--                        ball_x <= ball_x + ball_dx;
--                        ball_y <= ball_y + ball_dy;
--                    ELSE
--                        ball_x <= 640/2;
--                        ball_y <= 480/2;
--                    END IF;
--                ELSE
--                    ball_x <= ball_x + ball_dx;
--                    ball_y <= ball_y + ball_dy;
--                END IF;

--                -- Umdrehung der y Bewegung, wenn wir mit Boden oder Decke Kollidieren
--                IF (ball_y < BALL_RADIUS) THEN
--                    ball_dy <= 1;
--                    ball_x <= ball_x + ball_dx;
--                    ball_y <= ball_y + ball_dy;
--                END IF;
--                IF (ball_y > (480 - BALL_RADIUS - PADDLE_WIDTH - PADDLE_WALL_DIST)) THEN
--                    ball_dy <= - 1;
--                    ball_x <= ball_x + ball_dx;
--                    ball_y <= ball_y + ball_dy;
--                END IF;

--            END IF;
--        END IF;