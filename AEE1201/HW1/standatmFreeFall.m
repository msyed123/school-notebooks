function standatmFreeFall(mass_, cd_, area_)
    mass = mass_;
    C_d = cd_;
    A = area_;

    acceleration = [];
    velocity = [];
    height = [];
    presentVelocity = 0;
    presentHeight = 30480; % 100000 ft in meters
    previousVelocity = 0;
    previousHeight = 30480; 
    dt = 0.01;

    FORCE_GRAV = -9.81;


    while presentHeight >= 0
        [~,~,currentDensity] = standatm( presentHeight/1000 );
        drag = .5 * currentDensity * (presentVelocity ^ 2) * A * C_d;
        weight = mass * FORCE_GRAV;
        totalForce = drag + weight;
        presentAcceleration = totalForce / mass;
        presentVelocity = previousVelocity - presentAcceleration*dt;

        presentHeight = previousHeight - presentVelocity*dt;
        acceleration = [acceleration presentAcceleration];
        velocity = [velocity presentVelocity];
        height = [height presentHeight];

        previousVelocity = presentVelocity;
        previousHeight = presentHeight;
    end
    endTime = (size(acceleration) - 1) * dt;
    velocity = velocity .* -1;

    figure(1)
    subplot(3,2,[1 2])
    plot(0:dt:endTime(2), height)
    title("Altitude vs. Time")
    xlabel("Time (seconds)")
    ylabel("Altitude (meters)")

    subplot(3,2,[3 4])
    plot(0:dt:endTime(2), velocity)
    title("Velocity vs. Time")
    xlabel("Time (seconds)")
    ylabel("Velocity (meters/sec)")

    subplot(3,2,[5 6])
    plot(0:dt:endTime(2), acceleration)
    title("Acceleration vs. Time")
    xlabel("Time (seconds)")
    ylabel("Acceleration (meters/sec^2)")
    
    runTitle = sprintf("Mass: %d kg | Drag Coefficient: %.2f | Area: %d sq. m.", mass, C_d, A);
end