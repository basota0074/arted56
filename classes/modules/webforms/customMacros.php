<?php

	use UmiCms\Service;

	/** Класс пользовательских методов для всех режимов */
	class WebformsSolutionCustomMacros {

		/** @var webforms $module */
		public $module;

		public function custom_order_send() {

			$domain = htmlspecialchars(trim(getRequest('domain')));
			$page_link = htmlspecialchars(trim(getRequest('page_link')));
			$name = htmlspecialchars(trim(getRequest('order_name')));
			$name_title = htmlspecialchars(trim(getRequest('order_name_title')));
			$phone = htmlspecialchars(trim(getRequest('order_phone')));
			$phone_title = htmlspecialchars(trim(getRequest('order_phone_title')));
			$message = htmlspecialchars(trim(getRequest('order_message')));
			$message_title = htmlspecialchars(trim(getRequest('order_message_title')));

			$ajax_message['status'] = 0;
			$buffer = Service::Response()
				->getCurrentBuffer();

			if ($name == '') {
				$ajax_message['name'] = 1;
			}
			if ($phone == '') {
				$ajax_message['phone'] = 1;
			}
			if ($phone == '' || $name == '') {
				$ajax_message['status'] = 1;

				$buffer->push(json_encode($ajax_message));
				$buffer->end();
			}

			$mailContent = '<html>';
			$mailContent .= '<body>';
			$mailContent .= '<h3>Содержание сообщения:</h3>';
			$mailContent .= '<p><b>' . $name_title . '</b> ' . $name . '</p>';
			$mailContent .= '<p><b>' . $phone_title . '</b> ' . $phone . '</p>';
			if ($message != '') {
				$mailContent .= '<p><b>' . $message_title . '</b> ' . $message . '</p>';
			}
			$mailContent .= '<p><b>Страница, с которой отправлено сообщение:</b> <a href="' . $page_link . '">' . $page_link . '</a></p>';
			$mailContent .= "</body>\n";
			$mailContent .= "</html>\n";

			$regedit = Service::Registry();
			$mail = new umiMail;

			$sel = new selector('objects');
			$sel->types('object-type')->name('webforms', 'address');
			if (umiCount($sel->result())) {
				$sEmailsSet = $this->module->guessAddressValue($sel->first()->getId());
				$sEmailsSet = preg_replace("/[\s;,]+/", ',', $sEmailsSet);
				$arEmailsSet = explode(',', $sEmailsSet);
				foreach ($arEmailsSet as $email) {
					$mail->addRecipient($email);
				}
			} else {
				$email = $regedit->get('//settings/admin_email');
				$mail->addRecipient($email);
			}
			$mail->setSubject('Письмо с ' . $domain);
			$mail->setFrom($regedit->get('//settings/email_from'), $regedit->get('//settings/fio_from'));
			$mail->setPriorityLevel('highest');
			$mail->setContent($mailContent);
			$mail->commit();
			$mail->send();

			$buffer->push(json_encode($ajax_message));
			$buffer->end();
		}
	}
