#!/usr/bin/env roseus
(require :baxter "package://baxtereus/baxter-interface.l")
(load "package://jsk_2014_picking_challenge/euslisp/pod-lowres.l")
(load "package://jsk_2014_picking_challenge/euslisp/order-bin.l")
(load "package://aginika_baxter_picking/euslisp/pickup.l")
(ros::load-ros-manifest "jsk_2014_picking_challenge")
(ros::roseus "aginika_baxter_main")

(setq *bin-settings* nil)
(setq *order-list* nil)
(setq *picked-list* nil)

(defun target-cell(bin-name item-name)
  (let* ((index ( - (char bin-name 4) 65))
	 (row (mod index 3))
	 (col (/ index 3))
	 )
    (ros::ros-info "~A -> index : ~A ~A ~A" bin-name index row col)
    (list bin-name index row col)
    )
  )

(defun setup()
  (send *baxter* :reset-pose)
  (send *ri* :angle-vector (send *baxter* :angle-vector) 10000)
  )

(defun order-cb (msg)
  (setq *order-list* msg)
  (ros::ros-info "****** ORDER CB ******")
  (dolist (item (send msg :order_list))
    (if (not (member (send item :item) *picked-list*  :test #'equal))
	(progn
	  (ros::ros-info "Request ~A in ~A" (send item :item) (send item :bin))
	  (pick (target-cell (send item :bin) (send item :item)))
	  (push (send item :item) *picked-list*)
	  )
      (progn
	(ros::ros-info "Already picked ~A in ~A\n" (send item :item) (send item :bin))
	)
      )
    )
  (ros::ros-info "****** ORDER CB END ******")
  )

(defun main()
  (setup)
  (ros::subscribe "/semi/order_list"
		  jsk_2014_picking_challenge::order_list
		  #'order-cb)
  (ros::rate 1)
  (while (ros::ok)
    (ros::spin-once)
    (ros::sleep)
    )
  )

;;;;;;;;;;;;;;;; Initialize Baxter Related ;;;;;;;;;;;;;;;;;;;;;;;
(baxter-init)
(pod-init)
(orderbin-init)
(send *baxter* :translate #f(0 0 900) :world)
;;;;;;;;;;;;;;;; End Initialize Baxter Related ;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;; Subscribe Bin and Order ;;;;;;;;;;;;;;;;;;;;;;;;
(defun bin-setting-cb (msg)
  (setq *bin-settings* msg)
  )

(ros::subscribe "/semi/bin_contents"
		jsk_2014_picking_challenge::bins_content
		#'bin-setting-cb)

(ros::ros-info "Wait for JSON...")
(while (null *bin-settings*)
  (ros::spin-once)
  (unix:sleep 1)
  (print ".")
  )
(ros::unsubscribe "/semi/bin_contents")
(ros::ros-info "Got JSON Config topic")
(ros::ros-info "~A" *bin-settings*)
(ros::ros-info "~A" *order-list*)
;;;;;;;;;;;;;;;; End Subscribe Bin and Order ;;;;;;;;;;;;;;;;;;;;;;;;

(objects (list *baxter* *pod* *orderbin*))
(ros::ros-info "Please type (main)")
