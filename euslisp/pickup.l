(ros::load-ros-manifest "std_msgs")

(defun pick(target)
  (unix::sleep 5)
  (ros::advertise "/on_off_gripper" std_msgs::Bool 5)
  (setq pose1 #f(-6.37207 20.0391 -25.0269 -39.9902 60.0073 -19.9951 80.0244 -0.065918 -14.8535 -74.707 38.4961 131.836 -22.8516 29.751 -11.3599))
  (setq pose2 #f(-6.37207 19.9951 -25.0049 -40.0122 60.0073 -20.0391 80.0244 -0.021973 10.3271 -76.7285 36.8921 148.162 -1.09863 -63.5229 -7.229))

  (send *ri* :angle-vector-sequence (list pose1 pose2) (list 4000 4000))
  (send *ri* :wait-interpolation)

  (setq pose3 #f(-6.3501 20.0171 -24.9609 -40.0122 60.0293 -19.9292 80.0464 -0.021973 24.6313 -61.6333 25.8398 116.082 -1.2085 -47.0215 -10.2612))
  (setq pose4 #f(-6.37207 19.9951 -25.0049 -39.9463 59.9854 -19.9951 80.0024 0.0 25.5103 -55.1733 22.2144 113.928 -7.44873 -52.6904 -13.0298))

  (send *ri* :angle-vector-sequence (list pose3 pose4) (list 4000 4000))
  (send *ri* :wait-interpolation)

  (setq on-msg (instance std_msgs::Bool :init :data t))
  (ros::publish "/on_off_gripper" on-msg)

  (send *ri* :angle-vector-sequence (list pose4 pose3 pose2) (list 3000 3000 5000))
  (send *ri* :wait-interpolation)

  (setq pose5 #f(-6.3501 20.0171 -24.9609 -39.9683 60.0073 -19.9731 80.0244 0.021973 -33.1348 -27.2681 71.0376 132.561 -104.919 -45.813 66.8628))
  (setq pose6 #f(-6.39404 20.0171 -25.0049 -39.9683 60.0293 -20.0171 80.0244 0.021973 -27.1143 15.1392 89.165 129.001 -100.195 -44.6045 75.6079))
  (setq pose7 #f(-6.39404 19.9951 -24.9609 -40.0122 60.0073 -19.9951 80.0024 0.043945 -18.8745 30.1025 109.006 128.079 -82.5073 -42.9126 66.4233))
  (send *ri* :angle-vector-sequence (list pose5 pose6 pose7) (list 3000 3000 3000))
  (send *ri* :wait-interpolation)

  (unix::sleep 10)

  (setq pose8 #f(-6.37207 19.9951 -25.0049 -40.0342 60.0293 -20.0171 80.0684 -0.021973 -28.894 42.3853 92.0874 138.032 -114.082 47.7246 54.4043))
  (setq pose9 #f(-6.37207 19.9292 -25.0049 -40.0122 60.0293 -20.0391 80.0244 0.021973 -10.5908 59.9887 78.2007 109.248 -165.476 65.6982 32.1021))
  (setq pose10 #f(-6.39404 19.9731 -24.9829 -39.9683 59.9854 -19.9731 79.9805 -0.021973 16.3037 42.9565 88.374 71.6968 -132.034 58.1396 28.2129))


  (send *ri* :angle-vector-sequence (list pose8 pose9 pose10) (list 4000 4000 3000))
  (send *ri* :wait-interpolation)


  (setq off-msg (instance std_msgs::Bool :init :data nil))
  (ros::publish "/on_off_gripper" off-msg)
  (unix::sleep 5)

  (send *ri* :angle-vector-sequence (list pose9 pose8) (list 4000 4000))
  (send *ri* :wait-interpolation)
  (send *baxter* :reset-pose)
  (send *ri* :angle-vector (send *baxter* :angle-vector) 10000)


  )
